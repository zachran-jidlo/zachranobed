import { Timestamp, DocumentReference } from "firebase-admin/firestore";
import { db } from "../config/firebase";
import {
  Delivery,
  DeliveryState,
  DeliveryType,
  DeliveryTimeWindow,
  CarrierOrder,
} from "../models";
import { DateTime } from "luxon";
import { logger } from "firebase-functions/v2";

/**
 * Create a delivery document in Firestore with PREPARED state.
 * @param {object} deliveryData - The delivery data
 * @return {Promise<void>}
 */
export async function createDeliveryDocument(deliveryData: {
  carrierId: string;
  donorId: string;
  recipientId: string;
  deliveryDate: Date;
  deliveryIdentifier: string;
  pickupTimeWindow: { start: Date; end: Date };
  deliveryTimeWindow: { start: Date; end: Date };
  confirmationTime?: number;
}): Promise<void> {
  const delivery: Record<string, unknown> = {
    carrierId: deliveryData.carrierId,
    donorId: deliveryData.donorId,
    recipientId: deliveryData.recipientId,
    deliveryDate: Timestamp.fromDate(deliveryData.deliveryDate),
    state: "PREPARED" as DeliveryState,
    type: "FOOD_DELIVERY" as DeliveryType,
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
  };

  // Only include confirmationTime if it's defined
  if (deliveryData.confirmationTime !== undefined) {
    delivery.confirmationTime = deliveryData.confirmationTime;
  }

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
  // Get today's date range in Prague timezone
  const todayStart = DateTime.now()
    .setZone("Europe/Prague")
    .startOf("day")
    .toJSDate();

  const todayEnd = DateTime.now()
    .setZone("Europe/Prague")
    .endOf("day")
    .toJSDate();

  const startTimestamp = Timestamp.fromDate(todayStart);
  const endTimestamp = Timestamp.fromDate(todayEnd);

  logger.debug(
    `Loading deliveries between ${startTimestamp.toDate().toISOString()} and ${endTimestamp.toDate().toISOString()} in states: ${states.join(", ")}`,
  );

  // Use range query to handle deliveries with milliseconds in timestamp
  const snapshot = await db
    .collection("deliveries")
    .where("deliveryDate", ">=", startTimestamp)
    .where("deliveryDate", "<=", endTimestamp)
    .where("state", "in", states)
    .where("type", "==", "FOOD_DELIVERY")
    .where("carrierId", "!=", "disabled")
    .get();

  return snapshot.docs.map((doc) => ({
    ref: doc.ref,
    ...doc.data(),
  })) as Delivery[];
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
 * Load today's box deliveries in OFFERED state.
 * @return {Promise<Delivery[]>} - Array of box deliveries
 */
export async function getTodaysBoxDeliveries(): Promise<Delivery[]> {
  // Get today's date range in Prague timezone
  const todayStart = DateTime.now()
    .setZone("Europe/Prague")
    .startOf("day")
    .toJSDate();

  const todayEnd = DateTime.now()
    .setZone("Europe/Prague")
    .endOf("day")
    .toJSDate();

  const startTimestamp = Timestamp.fromDate(todayStart);
  const endTimestamp = Timestamp.fromDate(todayEnd);

  // Use range query to handle deliveries with milliseconds in timestamp
  const snapshot = await db
    .collection("deliveries")
    .where("deliveryDate", ">=", startTimestamp)
    .where("deliveryDate", "<=", endTimestamp)
    .where("type", "==", "BOX_DELIVERY")
    .where("state", "==", "OFFERED")
    .where("boxReturnCarrierId", "!=", "disabled")
    .get();

  return snapshot.docs.map((doc) => ({
    ref: doc.ref,
    ...doc.data(),
  })) as Delivery[];
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
