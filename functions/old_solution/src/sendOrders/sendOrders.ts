import { Timestamp } from 'firebase-admin/firestore'
import {
  COLLECTIONS,
  DeliveryStateRT,
  DeliveryTypeRT,
  EntityPair,
  Entity,
  getEntities,
  getEntityPairs
} from '../common/firestore.js'
import {
  DodoToken,
  DodoTokenRT,
  DODOOrder,
  getDodoToken,
  createOrder
} from '../common/dodo.js'
import { firestore } from '../common/index.js'
import { logError, logDebug, logInfo } from '../common/logger.js'
import { config } from '../common/config.js'
import {
  getDateInFuture,
  updateNoteWithWithPhoneNumbers
} from '../common/utils.js'

const CREATED_DELIVERY_DAYS_IN_FUTURE = 1

/**
 * Sends deliveries by loading entity pairs and entities from collections,
 * getting a temporary DODO oauth token, and handling the deliveries.
 * @returns {Promise<void>} A promise that resolves when the deliveries are sent successfully.
 */
export const sendDeliveries = async (): Promise<void> => {
  // Log some info about current configuration
  logDebug('===== Configuration info =====')
  logDebug(`Environment: ${config.NODE_ENV}`)
  logDebug(`Make API calls: ${config.MAKE_API_CALLS}`)
  logDebug(`Axios logging enabled: ${config.AXIOS_LOGGING_ENABLED}`)
  logDebug(`Timezone offset: ${new Date().getTimezoneOffset()} minutes`)
  logDebug('===== Configuration info =====')

  try {
    // Load entityPairs from entitiesPairs collection
    logInfo(
      `Loading entity pair(s) from "${COLLECTIONS.ENTITY_PAIRS}" collection`
    )
    const entityPairs = await getEntityPairs(firestore)
    logInfo(
      `Found ${entityPairs.length} entity pair(s) in "${COLLECTIONS.ENTITY_PAIRS}" collection`
    )

    // Load entities from entities collection
    logInfo(`Loading entity(s) from "${COLLECTIONS.ENTITIES}" collection`)
    const entities = await getEntities(firestore)
    logInfo(
      `Found ${entities.length} entity(s) in "${COLLECTIONS.ENTITIES}" collection`
    )

    logInfo('Getting temporary DODO oauth token')
    let dodoToken: null | DodoToken = null
    const dodoTokenResponse = await getDodoToken()

    if (config.MAKE_API_CALLS) {
      dodoToken = DodoTokenRT.check(dodoTokenResponse)
    }
    logInfo(
      `Successfully received temporary DODO oauth token (expires in ${dodoToken?.expires_in}s)`
    )

    // Call handleDeliveries with entityPairs and entities
    const handledDeliveriesCount = await handleDeliveries(
      entityPairs,
      entities,
      dodoToken
    )
    if (!handledDeliveriesCount) {
      throw new Error('No deliveries have been handled')
    }
  } catch (error) {
    logError('Script failed', error)
    process.exit(1)
  }
}

/**
 * Handles the deliveries for the given entity pairs.
 *
 * @param entityPairs - An array of entity pairs.
 * @param entities - An array of entities.
 * @param dodoToken - The Dodo token.
 * @returns The number of handled deliveries.
 */
const handleDeliveries = async (
  entityPairs: EntityPair[],
  entities: Entity[],
  dodoToken: DodoToken | null
): Promise<number> => {
  let handledDeliveriesCount = 0

  for (const entityPair of entityPairs) {
    try {
      logInfo(
        `|${handledDeliveriesCount}| Handling entity pair ${entityPair.donorId}-${entityPair.recipientId}/FBID: ${entityPair.ref.id} delivery`
      )

      const donor = entities.find(
        (entity) => entity.ref.id === entityPair.donorId
      )
      const recipient = entities.find(
        (entity) => entity.ref.id === entityPair.recipientId
      )

      logInfo(
        `|${handledDeliveriesCount}| -> Donor: ${donor?.establishmentName}/FBID(${donor?.ref.id})`
      )
      logInfo(
        `|${handledDeliveriesCount}| -> Recipient: ${recipient?.establishmentName}/FBID(${recipient?.ref.id})`
      )

      if (!donor || !recipient) {
        throw new Error('Donor or recipient not found')
      }

      const deliveryDate = getDateInFuture(CREATED_DELIVERY_DAYS_IN_FUTURE)

      const order: DODOOrder = {
        id: `${donor.establishmentId}-${
          recipient.establishmentId
        }-${deliveryDate.toLocaleDateString('cs')}`
          .toLowerCase()
          .replace(/ /g, ''),
        pickupDodoId: entityPair.carrierDonorId,
        pickupId: donor.establishmentId,
        pickupTo: getDateInFuture(
          CREATED_DELIVERY_DAYS_IN_FUTURE,
          entityPair.pickupTimeWindows[0].end
        ),
        pickupFrom: getDateInFuture(
          CREATED_DELIVERY_DAYS_IN_FUTURE,
          entityPair.pickupTimeWindows[0].start
        ),
        pickupNote: updateNoteWithWithPhoneNumbers(
          donor.noteForDriver || '',
          donor.phone,
          recipient.phone
        ),
        deliverAddress: `${recipient.street} ${recipient.houseNumber} ${recipient.city} ${recipient.postalCode}`,
        deliverId: recipient.establishmentId,
        deliverTo: getDateInFuture(
          CREATED_DELIVERY_DAYS_IN_FUTURE,
          entityPair.deliveryTimeWindows[0].end
        ),
        deliverFrom: getDateInFuture(
          CREATED_DELIVERY_DAYS_IN_FUTURE,
          entityPair.deliveryTimeWindows[0].start
        ),
        deliverNote: updateNoteWithWithPhoneNumbers(
          recipient.noteForDriver || '',
          donor.phone,
          recipient.phone
        ),
        customerName: recipient.responsiblePerson,
        customerPhone: recipient.phone
      }

      console.info(
        `-> Adding order ${order.id} to ${COLLECTIONS.DELIVERIES} collection`
      )
      await saveOrderToFirebase(order, entityPair, deliveryDate)

      handledDeliveriesCount++
    } catch (error) {
      logError('Handling delivery failed', error)
    }
  }

  return handledDeliveriesCount
}

/**
 * Saves an order to Firebase.
 *
 * @param order - The DODOOrder object representing the order.
 * @param entityPair - The EntityPair object representing the entities involved in the order.
 * @param deliverydate - The delivery date for the order.
 * @returns A Promise that resolves when the order is successfully saved to Firebase.
 */
const saveOrderToFirebase = async (
  order: DODOOrder,
  entityPair: EntityPair,
  deliverydate: Date
): Promise<void> => {
  const delivery = {
    carrierId: entityPair.carrierId,
    recipientId: entityPair.recipientId,
    donorId: entityPair.donorId,
    deliveryDate: Timestamp.fromDate(deliverydate),
    pickupTimeWindow: {
      start: Timestamp.fromDate(order.pickupFrom),
      end: Timestamp.fromDate(order.pickupTo)
    },
    deliveryTimeWindow: {
      start: Timestamp.fromDate(order.deliverFrom),
      end: Timestamp.fromDate(order.deliverTo)
    },
    foodBoxes: [],
    meals: [],
    state: DeliveryStateRT.PREPARED,
    type: DeliveryTypeRT.FOOD_DELIVERY,
    deliveryIdentifier: order.id,
    confirmationTime: entityPair.confirmationTime ?? 0
  }

  firestore.collection(COLLECTIONS.DELIVERIES).doc(order.id).set(delivery)
}
