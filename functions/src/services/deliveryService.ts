import { Timestamp, DocumentReference } from "firebase-admin/firestore";
import { db } from "../config/firebase";
import {
  Delivery,
  DeliverySchema,
  DeliveryState,
  DeliveryTimeWindow,
  CarrierOrder,
} from "../models";
import { DateTime } from "luxon";
import { logger } from "firebase-functions/v2";

/**
 * Parameters for creating a new delivery document.
 */
interface CreateDeliveryData {
  carrierId: string;
  donorId: string;
  recipientId: string;
  deliveryDate: Date;
  deliveryIdentifier: string;
  pickupTimeWindow: { start: Date; end: Date };
  deliveryTimeWindow: { start: Date; end: Date };
  confirmationTime?: number;
}

/**
 * Get today's date range in Prague timezone as Firestore Timestamps.
 * @return {{ start: Timestamp; end: Timestamp }} - Start and end timestamps for today
 */
function getTodayDateRange(): { start: Timestamp; end: Timestamp } {
  const todayStart = DateTime.now()
    .setZone("Europe/Prague")
    .startOf("day")
    .toJSDate();
  const todayEnd = DateTime.now()
    .setZone("Europe/Prague")
    .endOf("day")
    .toJSDate();

  return {
    start: Timestamp.fromDate(todayStart),
    end: Timestamp.fromDate(todayEnd),
  };
}

/**
 * Create a delivery document in Firestore with PREPARED state.
 * @param {CreateDeliveryData} deliveryData - The delivery data
 * @return {Promise<void>}
 */
export async function createDeliveryDocument(
  deliveryData: CreateDeliveryData,
): Promise<void> {
  const delivery = {
    carrierId: deliveryData.carrierId,
    donorId: deliveryData.donorId,
    recipientId: deliveryData.recipientId,
    deliveryDate: Timestamp.fromDate(deliveryData.deliveryDate),
    state: "PREPARED" as const,
    type: "FOOD_DELIVERY" as const,
    deliveryIdentifier: deliveryData.deliveryIdentifier,
    pickupTimeWindow: {
      start: Timestamp.fromDate(deliveryData.pickupTimeWindow.start),
      end: Timestamp.fromDate(deliveryData.pickupTimeWindow.end),
    },
    deliveryTimeWindow: {
      start: Timestamp.fromDate(deliveryData.deliveryTimeWindow.start),
      end: Timestamp.fromDate(deliveryData.deliveryTimeWindow.end),
    },
    foodBoxes: [],
    meals: [],
    ...(deliveryData.confirmationTime !== undefined && {
      confirmationTime: deliveryData.confirmationTime,
    }),
  };

  await db
    .collection("deliveries")
    .doc(deliveryData.deliveryIdentifier)
    .set(delivery);
}

/**
 * Load today's deliveries in specified states.
 * Uses Prague timezone to match how deliveries are created.
 * @param {DeliveryState[]} states - The states to filter by
 * @return {Promise<Delivery[]>} - Array of deliveries
 */
export async function getTodaysDeliveries(
  states: DeliveryState[],
): Promise<Delivery[]> {
  const { start, end } = getTodayDateRange();

  logger.debug(
    `Loading deliveries between ${start.toDate().toISOString()} and ${end.toDate().toISOString()} in states: ${states.join(", ")}`,
  );

  // Use range query to handle deliveries with milliseconds in timestamp
  const snapshot = await db
    .collection("deliveries")
    .where("deliveryDate", ">=", start)
    .where("deliveryDate", "<=", end)
    .where("state", "in", states)
    .where("type", "==", "FOOD_DELIVERY")
    .where("carrierId", "!=", "disabled")
    .get();

  return snapshot.docs
    .map((doc) => {
      const result = DeliverySchema.safeParse({
        ref: doc.ref,
        ...doc.data(),
      });
      if (!result.success) {
        logger.warn(`Invalid delivery document ${doc.id}:`, result.error);
        return null;
      }
      return result.data;
    })
    .filter((delivery): delivery is Delivery => delivery !== null);
}

/**
 * Update delivery state in Firestore.
 * @param {DocumentReference} deliveryRef - The delivery document reference
 * @param {DeliveryState} state - The new state
 * @return {Promise<void>}
 */
export async function updateDeliveryState(
  deliveryRef: DocumentReference,
  state: DeliveryState,
): Promise<void> {
  await deliveryRef.update({ state });
}

/**
 * Update delivery with order creation time.
 * @param {DocumentReference} deliveryRef - The delivery document reference
 * @param {CarrierOrder} carrierOrder - The carrier order metadata
 * @return {Promise<void>}
 */
export async function updateDeliveryWithOrderCreationTime(
  deliveryRef: DocumentReference,
  carrierOrder: CarrierOrder,
): Promise<void> {
  await deliveryRef.update({ carrierOrder });
}

/**
 * DODO status to Firestore delivery state mapping.
 */
const DODO_STATUS_TO_STATE: Record<string, DeliveryState> = {
  "OnWayToPickup": "ON_WAY_TO_PICK_UP",
  "OnWayToCustomer": "IN_DELIVERY",
  "ArrivedToCustomer": "DELIVERED",
};

/**
 * Update delivery state based on a DODO webhook status callback.
 * Looks up the delivery by deliveryIdentifier and transitions its state.
 * @param {string} identifier - The delivery identifier from DODO
 * @param {string} dodoStatus - The DODO order status
 * @return {Promise<{ updated: boolean; reason?: string }>}
 */
export async function updateDeliveryStateByDodoStatus(
  identifier: string,
  dodoStatus: string,
): Promise<{ updated: boolean; reason?: string }> {
  const newState = DODO_STATUS_TO_STATE[dodoStatus];
  if (!newState) {
    return { updated: false, reason: "no_mapping" };
  }

  const snapshot = await db
    .collection("deliveries")
    .where("deliveryIdentifier", "==", identifier)
    .limit(1)
    .get();

  if (snapshot.empty) {
    logger.warn(`Delivery not found for identifier: ${identifier}`);
    return { updated: false, reason: "not_found" };
  }

  const doc = snapshot.docs[0];
  await updateDeliveryState(doc.ref, newState);
  logger.info(
    `Updated delivery ${doc.id} state to ${newState} (DODO status: ${dodoStatus})`,
  );
  return { updated: true };
}

/**
 * Load today's box deliveries in OFFERED state.
 * @return {Promise<Delivery[]>} - Array of box deliveries
 */
export async function getTodaysBoxDeliveries(): Promise<Delivery[]> {
  const { start, end } = getTodayDateRange();

  // Use range query to handle deliveries with milliseconds in timestamp
  const snapshot = await db
    .collection("deliveries")
    .where("deliveryDate", ">=", start)
    .where("deliveryDate", "<=", end)
    .where("type", "==", "BOX_DELIVERY")
    .where("state", "==", "OFFERED")
    .get();

  return snapshot.docs
    .map((doc) => {
      const result = DeliverySchema.safeParse({
        ref: doc.ref,
        ...doc.data(),
      });
      if (!result.success) {
        logger.warn(`Invalid box delivery document ${doc.id}:`, result.error);
        return null;
      }
      return result.data;
    })
    .filter((delivery): delivery is Delivery => delivery !== null);
}

/**
 * Update box delivery with new state, identifier, time windows, and carrierId.
 * @param {DocumentReference} deliveryRef - The delivery document reference
 * @param {DeliveryState} state - The new state
 * @param {string} deliveryIdentifier - The new delivery identifier
 * @param {Date} deliveryDate - The delivery date
 * @param {DeliveryTimeWindow} pickupTimeWindow - The pickup time window
 * @param {DeliveryTimeWindow} deliveryTimeWindow - The delivery time window
 * @param {string} carrierId - The carrier ID
 * @return {Promise<void>}
 */
export async function updateBoxDelivery(
  deliveryRef: DocumentReference,
  state: DeliveryState,
  deliveryIdentifier: string,
  deliveryDate: Date,
  pickupTimeWindow: DeliveryTimeWindow,
  deliveryTimeWindow: DeliveryTimeWindow,
  carrierId: string,
): Promise<void> {
  await deliveryRef.update({
    state,
    deliveryIdentifier,
    deliveryDate: Timestamp.fromDate(deliveryDate),
    pickupTimeWindow,
    deliveryTimeWindow,
    carrierId,
  });
}
