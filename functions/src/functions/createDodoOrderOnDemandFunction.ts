/**
 * On-demand DODO order creation function.
 *
 * ## Security
 *
 * This function has NO built-in authentication — it relies entirely on
 * GCloud IAM. The `allUsers` principal has been removed from invokers,
 * so only authenticated callers with `roles/cloudfunctions.invoker` can
 * reach it. Unauthenticated requests are rejected with 403 by GCloud
 * before the function code executes.
 *
 * ### Grant access to a user/service account:
 * ```bash
 * gcloud functions add-invoker-policy-binding createDodoOrderOnDemand \
 *   --region=europe-west1 \
 *   --member="user:someone@example.com" \
 *   --gen2
 * ```
 *
 * ### Revoke access:
 * ```bash
 * gcloud functions remove-invoker-policy-binding createDodoOrderOnDemand \
 *   --region=europe-west1 \
 *   --member="user:someone@example.com" \
 *   --gen2
 * ```
 *
 * ### Call the function (authenticated):
 * ```bash
 * curl -X POST \
 *   -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
 *   -H "Content-Type: application/json" \
 *   https://europe-west1-PROJECT_ID.cloudfunctions.net/createDodoOrderOnDemand \
 *   -d '{"date":"2026-04-03","donorId":"...","recipientId":"...","type":"FOOD_DELIVERY","dryRun":true}'
 * ```
 */

import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { Timestamp } from "firebase-admin/firestore";
import { DateTime } from "luxon";
import { DeliveryType } from "../models";
import {
  db,
  dodoClientId,
  dodoClientSecret,
  dodoOauthUri,
  dodoScope,
  dodoOrdersApi,
} from "../config/firebase";
import { TIMEZONE, BOX_RETURN_SCHEDULE } from "../config/constants";
import {
  getEntityPairs,
  getEntities,
  clearEntityCache,
} from "../services/entityService";
import {
  createDeliveryDocument,
  updateDeliveryWithOrderCreationTime,
} from "../services/deliveryService";
import {
  getDodoToken,
  createDodoOrder,
  createFoodDeliveryOrder,
  createBoxReturnOrder,
} from "../services/dodoService";
import {
  scheduleMultipleTransitions,
  ScheduleTransitionParams,
} from "../services/cloudTaskService";
import { formatCzechDate, createDateWithTime } from "../utils/dateUtils";
import { getConfirmationMinutes } from "../utils/deliveryUtils";

const VALID_TYPES: DeliveryType[] = ["FOOD_DELIVERY", "BOX_DELIVERY"];

/**
 * Coerce a value to boolean. Handles string "true"/"false" from query params.
 */
function toBool(value: unknown): boolean {
  if (typeof value === "boolean") return value;
  if (typeof value === "string") return value.toLowerCase() === "true";
  return false;
}

/**
 * On-demand HTTP function to create a DODO carrier order for a specific
 * entity pair and date. Supports dry-run mode and optional delivery document creation.
 *
 * Enable/disable via GCloud Console.
 */
export const createDodoOrderOnDemand = onRequest(
  {
    secrets: [
      dodoClientId,
      dodoClientSecret,
      dodoOauthUri,
      dodoScope,
      dodoOrdersApi,
    ],
  },
  async (req, res) => {
    const dateStr = (req.body?.date || req.query.date) as string | undefined;
    const donorId = (req.body?.donorId || req.query.donorId) as
      | string
      | undefined;
    const recipientId = (req.body?.recipientId || req.query.recipientId) as
      | string
      | undefined;
    const type = (req.body?.type || req.query.type) as string | undefined;
    const createDeliveryFlag = toBool(
      req.body?.createDelivery ?? req.query.createDelivery,
    );
    const dryRun = toBool(req.body?.dryRun ?? req.query.dryRun);

    // --- Validation ---
    if (!dateStr || !donorId || !recipientId || !type) {
      res.status(400).json({
        status: "error",
        message:
          "Missing required parameters: date, donorId, recipientId, type",
      });
      return;
    }

    if (!VALID_TYPES.includes(type as DeliveryType)) {
      res.status(400).json({
        status: "error",
        message: `Invalid type "${type}". Must be FOOD_DELIVERY or BOX_DELIVERY`,
      });
      return;
    }

    const deliveryType = type as DeliveryType;

    const parsed = DateTime.fromISO(dateStr, { zone: TIMEZONE });
    if (!parsed.isValid) {
      res.status(400).json({
        status: "error",
        message: `Invalid date format. Use YYYY-MM-DD. Error: ${parsed.invalidReason}`,
      });
      return;
    }

    const deliveryDate = parsed.startOf("day").toJSDate();

    logger.info(
      `createDodoOrderOnDemand: type=${deliveryType} date=${dateStr} donor=${donorId} recipient=${recipientId} createDelivery=${createDeliveryFlag} dryRun=${dryRun}`,
    );

    try {
      // --- Load entities ---
      const [entityPairs, entities] = await Promise.all([
        getEntityPairs(),
        getEntities(),
      ]);

      const entityPair = entityPairs.find(
        (p) => p.donorId === donorId && p.recipientId === recipientId,
      );

      if (!entityPair) {
        res.status(404).json({
          status: "error",
          message: `Entity pair not found for donor=${donorId} recipient=${recipientId}. The pair may be disabled.`,
        });
        return;
      }

      const donor = entities.find((e) => e.id === donorId);
      const recipient = entities.find((e) => e.id === recipientId);

      if (!donor || !recipient) {
        res.status(404).json({
          status: "error",
          message:
            `Entity not found: ${!donor ? "donor " + donorId : ""} ${!recipient ? "recipient " + recipientId : ""}`.trim(),
        });
        return;
      }

      // --- Resolve carrier ---
      const carrierId =
        deliveryType === "FOOD_DELIVERY"
          ? entityPair.carrierId
          : entityPair.boxReturnCarrierId;

      if (carrierId === "disabled") {
        res.status(400).json({
          status: "error",
          message: `Carrier is disabled for ${deliveryType} on this entity pair`,
        });
        return;
      }

      // --- Compute time windows ---
      let pickupStart: Date;
      let pickupEnd: Date;
      let deliveryStart: Date;
      let deliveryEnd: Date;

      if (deliveryType === "FOOD_DELIVERY") {
        const pickupWindow = entityPair.pickupTimeWindows[0];
        const deliveryWindow = entityPair.deliveryTimeWindows[0];

        if (!pickupWindow || !deliveryWindow) {
          res.status(400).json({
            status: "error",
            message: "Entity pair has no time windows configured",
          });
          return;
        }

        pickupStart = createDateWithTime(deliveryDate, pickupWindow.start);
        pickupEnd = createDateWithTime(deliveryDate, pickupWindow.end);
        deliveryStart = createDateWithTime(deliveryDate, deliveryWindow.start);
        deliveryEnd = createDateWithTime(deliveryDate, deliveryWindow.end);
      } else {
        pickupStart = createDateWithTime(
          deliveryDate,
          BOX_RETURN_SCHEDULE.PICKUP.start,
        );
        pickupEnd = createDateWithTime(
          deliveryDate,
          BOX_RETURN_SCHEDULE.PICKUP.end,
        );
        deliveryStart = createDateWithTime(
          deliveryDate,
          BOX_RETURN_SCHEDULE.DELIVERY.start,
        );
        deliveryEnd = createDateWithTime(
          deliveryDate,
          BOX_RETURN_SCHEDULE.DELIVERY.end,
        );
      }

      // --- Generate delivery identifier ---
      const dateForId = formatCzechDate(deliveryDate);
      const deliveryIdentifier =
        deliveryType === "FOOD_DELIVERY"
          ? `${donor.establishmentId}-${recipient.establishmentId}-${dateForId}`
          : `${recipient.establishmentId}-${donor.establishmentId}-${dateForId}`
              .toLowerCase()
              .replace(/ /g, "");

      // --- Build DODO order ---
      const order =
        deliveryType === "FOOD_DELIVERY"
          ? createFoodDeliveryOrder(
              entityPair,
              donor,
              recipient,
              deliveryIdentifier,
              pickupStart,
              pickupEnd,
              deliveryStart,
              deliveryEnd,
            )
          : createBoxReturnOrder(
              entityPair,
              donor,
              recipient,
              deliveryIdentifier,
              pickupStart,
              pickupEnd,
              deliveryStart,
              deliveryEnd,
            );

      // --- Execute actions ---
      const actions: { action: string; status: string; detail?: string }[] = [];

      if (dryRun) {
        actions.push({ action: "dry_run", status: "no_actions_taken" });
      } else {
        // Create delivery document if requested
        if (createDeliveryFlag) {
          if (deliveryType === "FOOD_DELIVERY") {
            await createDeliveryDocument({
              carrierId,
              donorId,
              recipientId,
              deliveryDate,
              deliveryIdentifier,
              pickupTimeWindow: { start: pickupStart, end: pickupEnd },
              deliveryTimeWindow: { start: deliveryStart, end: deliveryEnd },
              confirmationTime: entityPair.confirmationTime,
            });
            actions.push({
              action: "create_delivery_document",
              status: "success",
              detail: `FOOD_DELIVERY created with state PREPARED, id=${deliveryIdentifier}`,
            });
          } else {
            // BOX_DELIVERY: write inline (matches boxDeliveryCreatedFunction pattern)
            const boxDeliveryDoc = {
              carrierId,
              donorId,
              recipientId,
              deliveryDate: Timestamp.fromDate(deliveryDate),
              state: "ACCEPTED" as const,
              type: "BOX_DELIVERY" as const,
              deliveryIdentifier,
              pickupTimeWindow: {
                start: Timestamp.fromDate(pickupStart),
                end: Timestamp.fromDate(pickupEnd),
              },
              deliveryTimeWindow: {
                start: Timestamp.fromDate(deliveryStart),
                end: Timestamp.fromDate(deliveryEnd),
              },
              foodBoxes: [],
              meals: [],
            };
            await db
              .collection("deliveries")
              .doc(deliveryIdentifier)
              .set(boxDeliveryDoc);
            actions.push({
              action: "create_delivery_document",
              status: "success",
              detail: `BOX_DELIVERY created with state ACCEPTED, id=${deliveryIdentifier}`,
            });
          }
        }

        // Create DODO order if carrier is dodo
        if (carrierId === "dodo") {
          const dodoToken = await getDodoToken();
          const orderCreated = await createDodoOrder(order, dodoToken);

          if (orderCreated) {
            actions.push({
              action: "create_dodo_order",
              status: "success",
              detail: `DODO order created for ${deliveryIdentifier}`,
            });

            // Update carrierOrder on delivery document if it exists
            if (createDeliveryFlag) {
              const deliveryRef = db
                .collection("deliveries")
                .doc(deliveryIdentifier);
              await updateDeliveryWithOrderCreationTime(deliveryRef, {
                createdAt: Timestamp.now(),
              });
              actions.push({
                action: "update_carrier_order",
                status: "success",
              });
            }
          } else {
            actions.push({
              action: "create_dodo_order",
              status: "failed",
              detail: "DODO API returned error",
            });
          }
        } else {
          actions.push({
            action: "create_dodo_order",
            status: "skipped",
            detail: `Carrier is "${carrierId}", not dodo`,
          });

          // For personal carrier with createDelivery + BOX_DELIVERY, set carrierOrder
          if (
            createDeliveryFlag &&
            carrierId === "personal" &&
            deliveryType === "BOX_DELIVERY"
          ) {
            const deliveryRef = db
              .collection("deliveries")
              .doc(deliveryIdentifier);
            await updateDeliveryWithOrderCreationTime(deliveryRef, {
              createdAt: Timestamp.now(),
            });
          }
        }

        // Schedule Cloud Tasks if delivery was created
        if (createDeliveryFlag) {
          const tasks: ScheduleTransitionParams[] = [];

          if (deliveryType === "FOOD_DELIVERY") {
            const confirmationMinutes = getConfirmationMinutes({
              carrierId,
              confirmationTime: entityPair.confirmationTime,
            });
            const notUsedAt = new Date(
              pickupStart.getTime() - confirmationMinutes * 60 * 1000,
            );

            tasks.push({
              deliveryId: deliveryIdentifier,
              targetState: "NOT_USED",
              preconditionState: "PREPARED",
              executeAt: notUsedAt,
            });

            if (carrierId === "personal") {
              tasks.push(
                {
                  deliveryId: deliveryIdentifier,
                  targetState: "ON_WAY_TO_PICK_UP",
                  preconditionState: "ACCEPTED",
                  executeAt: pickupStart,
                },
                {
                  deliveryId: deliveryIdentifier,
                  targetState: "IN_DELIVERY",
                  preconditionState: "ON_WAY_TO_PICK_UP",
                  executeAt: pickupEnd,
                },
                {
                  deliveryId: deliveryIdentifier,
                  targetState: "DELIVERED",
                  preconditionState: "IN_DELIVERY",
                  executeAt: deliveryEnd,
                },
              );
            }
          } else {
            // BOX_DELIVERY: schedule from ACCEPTED onwards (personal carrier only)
            if (carrierId === "personal") {
              tasks.push(
                {
                  deliveryId: deliveryIdentifier,
                  targetState: "ON_WAY_TO_PICK_UP",
                  preconditionState: "ACCEPTED",
                  executeAt: pickupStart,
                },
                {
                  deliveryId: deliveryIdentifier,
                  targetState: "IN_DELIVERY",
                  preconditionState: "ON_WAY_TO_PICK_UP",
                  executeAt: pickupEnd,
                },
                {
                  deliveryId: deliveryIdentifier,
                  targetState: "DELIVERED",
                  preconditionState: "IN_DELIVERY",
                  executeAt: deliveryEnd,
                },
              );
            }
          }

          if (tasks.length > 0) {
            await scheduleMultipleTransitions(tasks);
            actions.push({
              action: "schedule_cloud_tasks",
              status: "success",
              detail: `${tasks.length} task(s) scheduled`,
            });
          }
        }
      }

      // --- Response ---
      res.json({
        status: "success",
        dryRun,
        deliveryIdentifier,
        type: deliveryType,
        date: dateStr,
        carrierId,
        donor: {
          id: donorId,
          name: donor.establishmentName,
          establishmentId: donor.establishmentId,
        },
        recipient: {
          id: recipientId,
          name: recipient.establishmentName,
          establishmentId: recipient.establishmentId,
        },
        timeWindows: {
          pickup: {
            start: pickupStart.toISOString(),
            end: pickupEnd.toISOString(),
          },
          delivery: {
            start: deliveryStart.toISOString(),
            end: deliveryEnd.toISOString(),
          },
        },
        order: {
          id: order.id,
          pickupDodoId: order.pickupDodoId,
          pickupFrom: order.pickupFrom.toISOString(),
          pickupTo: order.pickupTo.toISOString(),
          pickupNote: order.pickupNote,
          deliverAddress: order.deliverAddress,
          deliverFrom: order.deliverFrom.toISOString(),
          deliverTo: order.deliverTo.toISOString(),
          deliverNote: order.deliverNote,
          customerName: order.customerName,
          customerPhone: order.customerPhone,
        },
        actions,
      });
    } catch (error) {
      logger.error("createDodoOrderOnDemand failed:", error);
      res.status(500).json({
        status: "error",
        message: error instanceof Error ? error.message : "Unknown error",
      });
    } finally {
      clearEntityCache();
    }
  },
);
