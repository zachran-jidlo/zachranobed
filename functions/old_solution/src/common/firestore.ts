import {
  Record,
  String,
  Optional,
  Array,
  InstanceOf,
  Number,
  Static as StaticRT
} from 'runtypes'
import {
  Timestamp,
  DocumentReference,
  Firestore,
  CollectionReference
} from 'firebase-admin/firestore'

export const COLLECTIONS = {
  ENTITIES: 'entities',
  ENTITY_PAIRS: 'entityPairs',
  DELIVERIES: 'deliveries'
}

export enum DeliveryStateRT {
  PREPARED = 'PREPARED',
  OFFERED = 'OFFERED',
  ACCEPTED = 'ACCEPTED',
  IN_DELIVERY = 'IN_DELIVERY',
  DELIVERED = 'DELIVERED',
  NOT_USED = 'NOT_USED'
}

export enum DeliveryTypeRT {
  FOOD_DELIVERY = 'FOOD_DELIVERY',
  BOX_DELIVERY = 'BOX_DELIVERY'
}

export const TimeWindowRT = Record({
  start: String, // "16:30"
  end: String // "17:00"
})

export const DeliveryTimeWindowRT = Record({
  start: InstanceOf(Timestamp), // "16:30"
  end: InstanceOf(Timestamp) // "17:00"
})

export const CarrierOrderRT = Record({
  createdAt: InstanceOf(Timestamp)
})

export const EntityRT = Record({
  id: String, // "zj-ad-zizkov"
  email: String, // "jonh@doe.com
  establishmentName: String, // "Charita 1"
  establishmentId: String, // "primirest-tanvald"
  organization: String, // "Charita 1"
  entityType: String, // "DONOR" | "RECIPIENT"
  phone: String, // +420123999888
  responsiblePerson: String, // Anna Strejcová
  city: String, // Prague
  street: String, // Spojená
  houseNumber: String, // 866/63
  postalCode: String, // 130 00
  noteForDriver: Optional(String) // zajděte za roh a a zazvoňte na zvonek
})

export const EntityPairRT = Record({
  donorId: String, // "zj-ad-zizkov"
  recipientId: String, // "zj-ad-zizkov"
  orderStatus: String, // "WAITING" | "CONFIRMED" | "CANCELED"
  carrierDonorId: String, // "zj-ad-zizkov"
  carrierRecipientId: String, // "zj-ad-zizkov"
  carrierId: String, // "dodo"
  boxReturnCarrierId: String, // "dodo"
  deliveryTimeWindows: Array(TimeWindowRT),
  pickupTimeWindows: Array(TimeWindowRT),
  confirmationTime: Optional(Number)
})

export const DeliveryRT = Record({
  carrierId: String, // "dodo"
  recipientId: String, // "zj-ad-zizkov"
  donorId: String, // "zj-ad-zizkov"

  deliveryDate: InstanceOf(Timestamp), // "2021-09-01T00:00:00Z"

  pickupTimeWindow: DeliveryTimeWindowRT,
  deliveryTimeWindow: DeliveryTimeWindowRT,

  state: String, // PREPARED, OFFERED, ACCEPTED, IN_DELIVERY, DELIVERED, NOT_USED

  type: String, //  FOOD_DELIVERY, BOX_DELIVERY

  deliveryIdentifier: String, // "dodo-123"

  carrierOrder: Optional(CarrierOrderRT),

  confirmationTime: Optional(Number)
})

export type Delivery = StaticRT<typeof DeliveryRT> & { ref: DocumentReference }
export type EntityPair = StaticRT<typeof EntityPairRT> & {
  ref: DocumentReference
}
export type Entity = StaticRT<typeof EntityRT> & { ref: DocumentReference }
export type DeliveryTimeWindow = StaticRT<typeof DeliveryTimeWindowRT> & {
  ref: DocumentReference
}
export type CarrierOrder = StaticRT<typeof CarrierOrderRT> & {
  ref: DocumentReference
}

export const getDeliveries = async (
  firestore: Firestore
): Promise<Delivery[]> => {
  // WARN: The handle orders function is prepared to handle only orders in state PREPARED, OFFERED, ACCEPTED, in case of change in the query, the function should be updated.
  return firestore
    .collection(COLLECTIONS.DELIVERIES)
    .where('state', 'in', [
      DeliveryStateRT.PREPARED,
      DeliveryStateRT.OFFERED,
      DeliveryStateRT.ACCEPTED
    ])
    .where(
      'pickupTimeWindow.start',
      '>',
      Timestamp.fromDate(new Date(new Date().setUTCHours(0, 0)))
    )
    .where(
      'pickupTimeWindow.start',
      '<',
      Timestamp.fromDate(new Date(new Date().setUTCHours(23, 59)))
    )
    .where('carrierId', '!=', 'disabled')
    .get()
    .then((snapshot) => {
      const data = snapshot.docs.map((doc) => {
        const delivery = doc.data() as Delivery
        delivery.ref = doc.ref
        return delivery
      })
      return data
    })
}

export const getTodaysBoxDeliveries = async (
  firestore: Firestore
): Promise<Delivery[]> => {
  return firestore
    .collection(COLLECTIONS.DELIVERIES)
    .where('type', '==', DeliveryTypeRT.BOX_DELIVERY)
    .where('deliveryDate', '>=', new Date(new Date().setUTCHours(0, 0)))
    .where('deliveryDate', '<=', new Date(new Date().setUTCHours(23, 59)))
    .get()
    .then((snapshot) => {
      const data = snapshot.docs.map((doc) => {
        const delivery = doc.data() as Delivery
        delivery.ref = doc.ref
        return delivery
      })
      return data
    })
}

export const updateOrderStatus = async (
  firestore: Firestore,
  deliveryRef: DocumentReference,
  state: DeliveryStateRT = DeliveryStateRT.PREPARED
): Promise<void> => {
  await firestore
    .collection(COLLECTIONS.DELIVERIES)
    .doc(deliveryRef.id)
    .update({ state })
}

export const updateDeliveryWithOrderCreationTime = async (
  firestore: Firestore,
  deliveryRef: DocumentReference,
  carrierOrder: CarrierOrder
): Promise<void> => {
  await firestore
    .collection(COLLECTIONS.DELIVERIES)
    .doc(deliveryRef.id)
    .update({ carrierOrder })
}

export type BoxDeliveryTimeWindow = {
  start: Timestamp
  end: Timestamp
}

export const updateBoxDelivery = async (
  firestore: Firestore,
  deliveryRef: DocumentReference,
  state: DeliveryStateRT = DeliveryStateRT.PREPARED,
  deliveryIdentifier: string,
  deliveryDate: Date,
  pickupTimeWindow: BoxDeliveryTimeWindow,
  deliveryTimeWindow: BoxDeliveryTimeWindow,
  carrierId: string
): Promise<void> => {
  await firestore
    .collection(COLLECTIONS.DELIVERIES)
    .doc(deliveryRef.id)
    .update({
      state,
      deliveryIdentifier,
      deliveryDate: Timestamp.fromDate(deliveryDate),
      pickupTimeWindow,
      deliveryTimeWindow,
      carrierId
    })
}

/**
 * Retrieves the entity pairs from Firestore.
 * @param firestore - The Firestore instance.
 * @returns A promise that resolves to an array of EntityPair objects.
 */
export const getEntityPairs = async (
  firestore: Firestore
): Promise<EntityPair[]> => {
  return firestore
    .collection(COLLECTIONS.ENTITY_PAIRS)
    .where('carrierId', '!=', 'disabled')
    .get()
    .then((snapshot) => {
      const data = snapshot.docs.map((doc) => {
        const entityPair = doc.data() as EntityPair
        entityPair.ref = doc.ref
        return entityPair
      })
      return data
    })
}

/**
 * Retrieves all entities from Firestore.
 * @param firestore - The Firestore instance.
 * @returns A promise that resolves to an array of entities.
 */
export const getEntities = async (firestore: Firestore): Promise<Entity[]> => {
  return firestore
    .collection(COLLECTIONS.ENTITIES)
    .get()
    .then((snapshot) => {
      const data = snapshot.docs.map((doc) => {
        const entity = doc.data() as Entity
        entity.ref = doc.ref
        return entity
      })
      return data
    })
}
