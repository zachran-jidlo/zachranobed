import { Timestamp, DocumentReference } from "firebase-admin/firestore";
import { db } from "../config/firebase";
import {
  Delivery,
  DeliverySchema,
  DeliveryState,
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
 * Load deliveries for a specific date in the specified states (all delivery types).
 * @param {Date} date - The delivery date
 * @param {DeliveryState[]} states - The states to filter by
 * @return {Promise<Delivery[]>} - Array of deliveries
 */
export async function getDeliveriesByDateAndStates(
  date: Date,
  states: DeliveryState[],
): Promise<Delivery[]> {
  const dateStart = DateTime.fromJSDate(date)
    .setZone("Europe/Prague")
    .startOf("day")
    .toJSDate();
  const dateEnd = DateTime.fromJSDate(date)
    .setZone("Europe/Prague")
    .endOf("day")
    .toJSDate();

  // TODO: Create Firestore index for deliveryDate + state to optimize this query.
  const snapshot = await db
    .collection("deliveries")
    .where("deliveryDate", ">=", Timestamp.fromDate(dateStart))
    .where("deliveryDate", "<=", Timestamp.fromDate(dateEnd))
    .where("state", "in", states)
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
 * Initialize box delivery document with server-calculated fields not set by the mobile app.
 * Mirrors the fields written by the old checkOrdersFunction: identifier, date, time windows, carrier.
 * @param {DocumentReference} deliveryRef - The delivery document reference
 * @param {string} deliveryIdentifier - Calculated delivery identifier
 * @param {Date} deliveryDate - Calculated delivery date (tomorrow)
 * @param {Date} pickupStart - Pickup window start
 * @param {Date} pickupEnd - Pickup window end
 * @param {Date} deliveryStart - Delivery window start
 * @param {Date} deliveryEnd - Delivery window end
 * @param {string} carrierId - The resolved carrier ID from EntityPair.boxReturnCarrierId
 * @return {Promise<void>}
 */
export async function initializeBoxDelivery(
  deliveryRef: DocumentReference,
  deliveryIdentifier: string,
  deliveryDate: Date,
  pickupStart: Date,
  pickupEnd: Date,
  deliveryStart: Date,
  deliveryEnd: Date,
  carrierId: string,
): Promise<void> {
  await deliveryRef.update({
    deliveryIdentifier,
    deliveryDate: Timestamp.fromDate(deliveryDate),
    carrierId,
    pickupTimeWindow: {
      start: Timestamp.fromDate(pickupStart),
      end: Timestamp.fromDate(pickupEnd),
    },
    deliveryTimeWindow: {
      start: Timestamp.fromDate(deliveryStart),
      end: Timestamp.fromDate(deliveryEnd),
    },
  });
}

