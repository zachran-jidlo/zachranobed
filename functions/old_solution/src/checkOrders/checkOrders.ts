import {
  COLLECTIONS,
  DeliveryStateRT,
  Delivery,
  BoxDeliveryTimeWindow,
  CarrierOrder,
  getDeliveries,
  getTodaysBoxDeliveries,
  getEntityPairs,
  getEntities,
  updateOrderStatus,
  updateDeliveryWithOrderCreationTime,
  updateBoxDelivery,
  EntityPair,
  Entity
} from '../common/firestore.js'
import { Timestamp } from 'firebase-admin/firestore'
import {
  DodoToken,
  DodoTokenRT,
  getDodoToken,
  DODOOrder,
  createOrder
} from '../common/dodo.js'
import { firestore } from '../common/index.js'
import { logDebug, logError, logInfo, logWarn } from '../common/logger.js'
import { config } from '../common/config.js'
import {
  getDateInFuture,
  updateNoteWithWithPhoneNumbers
} from '../common/utils.js'

const CREATED_DELIVERY_DAYS_IN_FUTURE = 1

/**
 * Runs the checks for orders.
 * This function logs some information about the current configuration,
 * gets a temporary DODO oauth token, and then performs checks on deliveries and box return deliveries.
 *
 * @returns {Promise<void>} A promise that resolves when the checks are completed.
 */
export const runChecks = async (): Promise<void> => {
  // Log some info about current configuration
  logDebug('===== Configuration info =====')
  logDebug(`Environment: ${config.NODE_ENV}`)
  logDebug(`Make API calls: ${config.MAKE_API_CALLS}`)
  logDebug(`Axios logging enabled: ${config.AXIOS_LOGGING_ENABLED}`)
  logDebug(`Timezone offset: ${new Date().getTimezoneOffset()} minutes`)
  logDebug('===== Configuration info =====')

  let dodoToken: null | DodoToken = null

  if (!dodoToken) {
    logInfo('Getting temporary DODO oauth token')
    const dodoTokenResponse = await getDodoToken()

    if (config.MAKE_API_CALLS) {
      dodoToken = DodoTokenRT.check(dodoTokenResponse)
    }
    logInfo(
      `Successfully received temporary DODO oauth token (expires in ${dodoToken?.expires_in}s)`
    )
  }

  await checkDeliveries(dodoToken)
  await checkBoxReturnDeliveries(dodoToken)
}

// ------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------- Food deliveries
// ------------------------------------------------------------------------------------------------------------------------

/**
 * Checks deliveries and handles orders.
 *
 * @param token - The DodoToken used for authentication.
 * @returns A Promise that resolves to the number of handled orders.
 */
export const checkDeliveries = async (token: DodoToken | null) => {
  try {
    logInfo(`Loading deliveries from "${COLLECTIONS.DELIVERIES}" collection`)
    const deliveries = await getDeliveries(firestore)
    logInfo(
      `Found ${deliveries.length} deliveries in "${COLLECTIONS.DELIVERIES}" collection`
    )

    const handledOrdersCount = await handleOrders(token, deliveries)
    if (handledOrdersCount !== deliveries.length) {
      throw new Error(
        `Only ${handledOrdersCount}/${deliveries.length} orders(s) were handled. Check logs for more info.`
      )
    }

    logInfo(
      `Script finished, ${handledOrdersCount} orders(s) have been handled`
    )
  } catch (error) {
    if (error instanceof Error) {
      logError(
        `Script failed while checking deliveries: ${error.message}`,
        error
      )
    } else {
      logError('Script failed while checking deliveries', error)
    }
    process.exit(1)
  }
}

/**
 * Handles the orders by checking their state and performing necessary actions.
 *
 * @param {DodoToken | null} token - The Dodo token used for authentication.
 * @param {Delivery[]} deliveries - An array of deliveries to be handled.
 * @returns {Promise<number>} A promise that resolves to the number of orders that were handled.
 */
const handleOrders = async (
  token: DodoToken | null,
  deliveries: Delivery[]
): Promise<number> => {
  let handledOrdersCount = 0

  for (const delivery of deliveries) {
    try {
      logInfo(
        `|${handledOrdersCount}| Handling delivery ${delivery.deliveryIdentifier}/FBID: ${delivery.ref.id}`
      )

      if (!delivery.pickupTimeWindow.start || !delivery.pickupTimeWindow.end) {
        logError(
          `|${handledOrdersCount}| Pickup time window is not defined for delivery ${delivery.deliveryIdentifier}`
        )
        continue
      }

      const pickupFrom = new Date(delivery.pickupTimeWindow.start.toDate())
      const pickupTo = new Date(delivery.pickupTimeWindow.end.toDate())

      const minutesBeforePickup = getMinutesConfirmedBeforePickup(delivery)
      logInfo(
        `|${handledOrdersCount}| Minutes before pickup: ${minutesBeforePickup}`
      )

      const latestConfirmationDate = new Date(
        new Date().setTime(
          pickupFrom.getTime() - minutesBeforePickup * 1000 * 60
        )
      )

      await handleDeliveryState(
        delivery,
        latestConfirmationDate,
        pickupTo,
        handledOrdersCount,
        token
      )
    } catch (error) {
      logError('Handling order failed', error)
    }
    handledOrdersCount++
  }

  return handledOrdersCount
}

/**
 * Handles the state of a delivery based on its current state and other parameters.
 *
 * @param delivery - The delivery object containing details about the delivery.
 * @param latestConfirmationDate - The latest date and time by which the delivery should be confirmed.
 * @param pickupTo - The date and time by which the delivery should be picked up.
 * @param handledOrdersCount - The count of orders that have been handled.
 * @param token - The Dodo token, which can be null.
 *
 * @remarks
 * If the delivery state is either ACCEPTED or OFFERED, the function adjusts the latest confirmation date
 * by adding a 30-minute buffer for Dodo deliveries to account for the nature of the CRON job and potential
 * delays after user confirmation. It then calls `handleAcceptedOrOfferedDelivery` with the adjusted date.
 *
 * If the delivery state is PREPARED, it calls `handlePreparedDelivery` with the original latest confirmation date.
 */
const handleDeliveryState = async (
  delivery: Delivery,
  latestConfirmationDate: Date,
  pickupTo: Date,
  handledOrdersCount: number,
  token: DodoToken | null
) => {
  if (
    delivery.state === DeliveryStateRT.ACCEPTED ||
    delivery.state === DeliveryStateRT.OFFERED
  ) {
    let correctedLatestConfirmationDate = latestConfirmationDate
    // There's a correction in dodo confirmation time because of nature or CRON job. It mitigates problem with user confirming the delivery in app but CRON running after the time is up.
    // Also the CRON job doesn't run at exact time, so we need to add some buffer. The buffer is 30 minutes for DODO.
    // This part is needed only for state ACCEPTED or OFFERED. In PREPARED state, if the time is up, the delivery is not used.
    if (delivery.carrierId === 'dodo') {
      correctedLatestConfirmationDate = new Date(
        latestConfirmationDate.getTime() + 30 * 60000
      )
    }

    await handleAcceptedOrOfferedDelivery(
      delivery,
      correctedLatestConfirmationDate,
      pickupTo,
      handledOrdersCount,
      token
    )
  } else if (delivery.state === DeliveryStateRT.PREPARED) {
    await handlePreparedDelivery(
      delivery,
      latestConfirmationDate,
      handledOrdersCount
    )
  }
}

/**
 * Handles the delivery based on its acceptance or offer status.
 *
 * @param delivery - The delivery object to be handled.
 * @param latestConfirmationDate - The latest date by which the delivery should be confirmed.
 * @param pickupTo - The date by which the delivery should be picked up.
 * @param handledOrdersCount - The count of orders that have been handled.
 * @param token - The DodoToken used for authentication, can be null.
 *
 * @returns A promise that resolves when the delivery has been handled.
 */
const handleAcceptedOrOfferedDelivery = async (
  delivery: Delivery,
  latestConfirmationDate: Date,
  pickupTo: Date,
  handledOrdersCount: number,
  token: DodoToken | null
) => {
  if (new Date() < latestConfirmationDate) {
    logDebug(`|${handledOrdersCount}| Order delivery`)
    await orderDeliveryIfNeeded(delivery, handledOrdersCount, token)
  } else {
    logDebug(
      `|${handledOrdersCount}| Handle accepted or offered delivery after confirmation`
    )
    await handleAcceptedOrOfferedDeliveryAfterConfirmation(
      delivery,
      latestConfirmationDate,
      pickupTo,
      handledOrdersCount
    )
  }
}

/**
 * Handles the delivery order creation if needed.
 *
 * @param delivery - The delivery object containing details about the delivery.
 * @param handledOrdersCount - The count of orders that have been handled so far. Used for logging.
 * @param token - The DodoToken used for authentication, can be null.
 *
 * @returns A promise that resolves when the delivery order process is complete.
 *
 * This function checks if the delivery already has an order created. If not, it proceeds to order the delivery.
 * It fetches necessary entities, determines the delivery participants, creates an order, sends the order, and updates the delivery with the order creation time.
 */
const orderDeliveryIfNeeded = async (
  delivery: Delivery,
  handledOrdersCount: number,
  token: DodoToken | null
) => {
  // Order already created.
  if (delivery.carrierOrder?.createdAt) {
    logInfo(
      `|${handledOrdersCount}| Delivery ${delivery.deliveryIdentifier} already ordered.`
    )
    return
  }

  logInfo(
    `|${handledOrdersCount}| Ordering delivery for ${delivery.deliveryIdentifier}.`
  )

  // Internally fetched only once, then cached.
  await fetchEntities(handledOrdersCount)
  if (!cachedEntityPairs || !cachedEntities) {
    return
  }

  const deliveryParticipants = getDeliveryParticipants(
    delivery,
    cachedEntityPairs,
    cachedEntities,
    handledOrdersCount
  )
  if (!deliveryParticipants) {
    return
  }

  const order = createDodoOrderFromDelivery(
    deliveryParticipants.entityPair,
    deliveryParticipants.donor,
    deliveryParticipants.recipient,
    delivery
  )
  await sendOrder(
    handledOrdersCount,
    deliveryParticipants.entityPair,
    order,
    token,
    deliveryParticipants.entityPair.carrierId
  )
  await updateDeliveryWithOrderCreationTime(firestore, delivery.ref, {
    createdAt: Timestamp.now()
  } as CarrierOrder)

  logInfo(
    `|${handledOrdersCount}| Successfully created order ${delivery.deliveryIdentifier}`
  )
}

/**
 * Handles the delivery process after the confirmation stage.
 *
 * @param delivery - The delivery object containing details about the delivery.
 * @param latestConfirmationDate - The latest date by which the delivery should have been confirmed.
 * @param pickupTo - The date by which the delivery should be picked up.
 * @param handledOrdersCount - The count of orders that have been handled so far. Used for logging.
 *
 * This function checks if the delivery has been created and if the current date is past the pickup date.
 * If the delivery has been created and the current date is past the pickup date, it moves the delivery to the IN_DELIVERY state.
 * If the delivery has not been created and the latest confirmation date has passed, it logs an error indicating that the delivery cannot be ordered.
 */
const handleAcceptedOrOfferedDeliveryAfterConfirmation = async (
  delivery: Delivery,
  latestConfirmationDate: Date,
  pickupTo: Date,
  handledOrdersCount: number
) => {
  if (delivery.carrierOrder?.createdAt) {
    // Order created, check if it's time to move it to IN_DELIVERY state.
    if (new Date() > pickupTo) {
      logInfo(
        `|${handledOrdersCount}| Moving delivery ${delivery.deliveryIdentifier} to IN_DELIVERY state.`
      )
      await updateOrderStatus(
        firestore,
        delivery.ref,
        DeliveryStateRT.IN_DELIVERY
      )
    } else {
      logInfo(
        `|${handledOrdersCount}| Delivery ${delivery.deliveryIdentifier} is not ready for pickup yet.`
      )
    }
  } else {
    // Time's up and the order was not created even though it should have been.
    logError(
      `|${handledOrdersCount}| Delivery for ${
        delivery.deliveryIdentifier
      } can't be ordered. Latest time for confirmation ${latestConfirmationDate.toLocaleString(
        'cs'
      )} passed.`
    )
  }
}

/**
 * Handles the prepared delivery by checking if the current date is past the latest confirmation date.
 * If the current date is past the latest confirmation date, it logs a warning and updates the order status to NOT_USED.
 * Otherwise, it logs that the delivery can still be requested.
 *
 * @param {Delivery} delivery - The delivery object containing delivery details.
 * @param {Date} latestConfirmationDate - The latest date by which the delivery can be confirmed.
 * @param {number} handledOrdersCount - The count of orders that have been handled so far.
 * @returns {Promise<void>} A promise that resolves when the order status has been updated or the log has been written.
 */
const handlePreparedDelivery = async (
  delivery: Delivery,
  latestConfirmationDate: Date,
  handledOrdersCount: number
) => {
  if (new Date() > latestConfirmationDate) {
    logWarn(
      `|${handledOrdersCount}| Delivery ${
        delivery.deliveryIdentifier
      } NOT USED. Latest time for confirmation ${latestConfirmationDate.toLocaleString(
        'cs'
      )} passed.`
    )

    await updateOrderStatus(firestore, delivery.ref, DeliveryStateRT.NOT_USED)
  } else {
    logInfo(
      `|${handledOrdersCount}| Delivery ${delivery.deliveryIdentifier} can still be requested.`
    )
  }
}

// ------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------- Box return deliveries
// ------------------------------------------------------------------------------------------------------------------------

/**
 * Checks and handles box deliveries.
 *
 * @param token - The DodoToken used for authentication.
 * @returns A Promise that resolves when the box deliveries have been checked and handled.
 */
export const checkBoxReturnDeliveries = async (token: DodoToken | null) => {
  logInfo(`Loading box deliveries from "${COLLECTIONS.DELIVERIES}" collection`)
  const deliveries = await getTodaysBoxDeliveries(firestore)
  logInfo(
    `Found ${deliveries.length} box deliveries in "${COLLECTIONS.DELIVERIES}" collection`
  )
  console.log(deliveries)

  if (deliveries.length === 0) {
    logInfo('No box deliveries found for today')
    return
  }

  let loggerDeliveryNumber = -1 // incremented to 0 at the beginning of the loop

  for (const delivery of deliveries) {
    loggerDeliveryNumber++
    logInfo(
      `|${loggerDeliveryNumber}| -> Handling box delivery FBID: ${delivery.ref.id}`
    )

    if (delivery.state !== DeliveryStateRT.OFFERED) {
      logInfo(
        `|${loggerDeliveryNumber}| -> Box delivery FBID: ${delivery.ref.id} is not in state OFFERED`
      )
      continue
    }

    // Internally fetched only once, then cached.
    await fetchEntities(loggerDeliveryNumber)
    if (!cachedEntityPairs || !cachedEntities) {
      return
    }

    const deliveryParticipants = getDeliveryParticipants(
      delivery,
      cachedEntityPairs,
      cachedEntities,
      loggerDeliveryNumber
    )
    if (!deliveryParticipants) {
      continue
    }
    const entityPair = deliveryParticipants.entityPair
    const donor = deliveryParticipants.donor
    const recipient = deliveryParticipants.recipient

    const deliveryDate = getDateInFuture(CREATED_DELIVERY_DAYS_IN_FUTURE)
    const deliveryIdentifier = `${recipient.establishmentId}-${
      donor.establishmentId
    }-${deliveryDate.toLocaleDateString('cs')}`
      .toLowerCase()
      .replace(/ /g, '')

    const pickupTimeWindow: BoxDeliveryTimeWindow = {
      start: Timestamp.fromDate(
        getDateInFuture(CREATED_DELIVERY_DAYS_IN_FUTURE, '10:00')
      ),
      end: Timestamp.fromDate(
        getDateInFuture(CREATED_DELIVERY_DAYS_IN_FUTURE, '10:30')
      )
    }
    const deliveryTimeWindow: BoxDeliveryTimeWindow = {
      start: Timestamp.fromDate(
        getDateInFuture(CREATED_DELIVERY_DAYS_IN_FUTURE, '11:00')
      ),
      end: Timestamp.fromDate(
        getDateInFuture(CREATED_DELIVERY_DAYS_IN_FUTURE, '11:30')
      )
    }

    const order: DODOOrder = {
      id: deliveryIdentifier,
      pickupDodoId: entityPair.carrierRecipientId,
      pickupId: recipient.establishmentId,
      pickupFrom: pickupTimeWindow.start.toDate(),
      pickupTo: pickupTimeWindow.end.toDate(),
      pickupNote:
        'Vyzvednutí obalů\n' +
        updateNoteWithWithPhoneNumbers(
          recipient.noteForDriver || '',
          recipient.phone,
          donor.phone
        ),
      deliverAddress: `${donor.street} ${donor.houseNumber} ${donor.city} ${donor.postalCode}`,
      deliverId: donor.establishmentId,
      deliverFrom: deliveryTimeWindow.start.toDate(),
      deliverTo: deliveryTimeWindow.end.toDate(),
      deliverNote:
        'Doručení obalů\n' +
        updateNoteWithWithPhoneNumbers(
          donor.noteForDriver || '',
          recipient.phone,
          donor.phone
        ),
      customerName: donor.responsiblePerson,
      customerPhone: donor.phone
    }

    const orderResult = await sendOrder(
      loggerDeliveryNumber,
      entityPair,
      order,
      token,
      entityPair.boxReturnCarrierId
    )

    if (orderResult) {
      logDebug(`|${loggerDeliveryNumber}| -> Order created successfully`)

      logInfo(
        `|${loggerDeliveryNumber}| ->  Box delivery in state OFFERED - moving to IN_DELIVERY state`
      )
      await updateBoxDelivery(
        firestore,
        delivery.ref,
        DeliveryStateRT.IN_DELIVERY,
        deliveryIdentifier,
        deliveryDate,
        pickupTimeWindow,
        deliveryTimeWindow,
        entityPair.boxReturnCarrierId
      )
      logInfo(
        `|${loggerDeliveryNumber}| -> Successfully moved box delivery ${delivery.deliveryIdentifier} to IN_DELIVERY state`
      )
    } else {
      logError(`|${loggerDeliveryNumber}| -> Failed to create order`)
    }
  }
}

/**
 * Handles the creation of an order based on the carrier type.
 *
 * @param handledDeliveriesCount - The number of handled deliveries.
 * @param entityPair - The entity pair.
 * @param order - The DODO order.
 * @param dodoToken - The DODO token.
 * @returns A Promise that resolves to true if order was created successfully, false otherwise.
 */
const sendOrder = async (
  loggerDeliveryNumber: number,
  entityPair: EntityPair,
  order: DODOOrder,
  dodoToken: DodoToken | null,
  carrierId: string
): Promise<boolean> => {
  switch (carrierId) {
    case 'dodo':
      logDebug(`|${loggerDeliveryNumber}| -> Carrier is DODO, creating order`)
      try {
        const response = await createOrder(order, dodoToken)

        // Check for non-200 status codes
        if (
          response.status &&
          (response.status < 200 || response.status >= 300)
        ) {
          logError(
            `|${loggerDeliveryNumber}| -> DODO API returned non-success status: ${
              response.status
            }. \
            Order ${
              order.id
            } creation failed but execution continues. Full Axios response object:\n ${JSON.stringify(
              response
            )}`
          )
          return false
        }

        logDebug(`|${loggerDeliveryNumber}| -> DODO order created successfully`)
      } catch (error) {
        // Handle axios errors and other exceptions
        if (error && typeof error === 'object' && 'isAxiosError' in error) {
          const axiosError = error as any
          logError(
            `|${loggerDeliveryNumber}| -> Axios error while creating DODO order ${
              order.id
            }: ${axiosError.message}. Status: ${
              axiosError.response?.status || 'unknown'
            }. Execution continues.`
          )
        } else {
          logError(
            `|${loggerDeliveryNumber}| -> Unexpected error while creating DODO order ${order.id}: ${error}. Execution continues.`
          )
        }

        return false
      }
      break

    case 'personal':
      logDebug(
        `|${loggerDeliveryNumber}| -> Carrier is personal, won't create order`
      )
      break

    default:
      // Only logging error. No need to throw an error here because we need to continue with the next delivery.
      logError(
        `|${loggerDeliveryNumber}| -> Carrier not supported ${entityPair.carrierId}`
      )
      return false
  }

  return true
}

// ------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------- Helper methods
// ------------------------------------------------------------------------------------------------------------------------

// Returns the number of minutes before the pickup time that the delivery should be confirmed.
//
// @param delivery - The delivery object.
// @returns The number of minutes before the pickup time that the delivery should be confirmed.
//
function getMinutesConfirmedBeforePickup(delivery: Delivery): number {
  // If the delivery has a confirmation time, use that.
  if (delivery.confirmationTime && delivery.confirmationTime > 0) {
    return delivery.confirmationTime
  }

  logWarn(
    `Delivery ${delivery.deliveryIdentifier} has no confirmation time. Falling back to default.`
  )

  // Fallback to default confirmation time based on carrier.
  switch (delivery.carrierId) {
    case 'dodo':
      return 45
    case 'personal':
      return 20
    default:
      throw new Error(`Carrier not supported ${delivery.carrierId}`)
  }
}

type DeliveryParticipants = {
  entityPair: EntityPair
  donor: Entity
  recipient: Entity
}

/**
 * Retrieves the delivery participants (donor and recipient) for a given delivery.
 *
 * @param {Delivery} delivery - The delivery object containing the donor and recipient IDs.
 * @param {EntityPair[]} entityPairs - An array of entity pairs linking donors and recipients.
 * @param {Entity[]} entities - An array of entities containing donor and recipient details.
 * @param {number} logNumber - A unique number used for logging purposes.
 * @returns {DeliveryParticipants | undefined} An object containing the entity pair, donor, and recipient if found, otherwise undefined.
 */
function getDeliveryParticipants(
  delivery: Delivery,
  entityPairs: EntityPair[],
  entities: Entity[],
  logNumber: number
): DeliveryParticipants | undefined {
  const entityPair = entityPairs.find(
    (entityPair) =>
      entityPair.donorId === delivery.donorId &&
      entityPair.recipientId === delivery.recipientId
  )
  if (!entityPair) {
    logWarn(
      `|${logNumber}| -> Entity pair for delivery FBID: ${delivery.ref.id} not found`
    )
    return
  } else {
    logDebug(
      `|${logNumber}| -> Entity pair for delivery FBID: ${
        delivery.ref.id
      } found: ${JSON.stringify(entityPair)}`
    )
  }

  const donor = entities.find((entity) => entity.ref.id === entityPair.donorId)
  const recipient = entities.find(
    (entity) => entity.ref.id === entityPair.recipientId
  )

  logDebug(
    `|${logNumber}| -> Donor for delivery FBID: ${
      delivery.ref.id
    } found: ${JSON.stringify(donor)}`
  )
  logDebug(
    `|${logNumber}| -> Recipient for delivery FBID: ${
      delivery.ref.id
    } found: ${JSON.stringify(recipient)}`
  )

  if (!donor || !recipient) {
    logWarn(
      `|${logNumber}| -> Donor or recipient for delivery FBID: ${delivery.ref.id} not found`
    )
    return
  }

  return {
    entityPair,
    donor,
    recipient
  }
}

/**
 * Creates a DODOOrder object from the given delivery details.
 *
 * @param {EntityPair} entityPair - The pair of entities involved in the delivery.
 * @param {Entity} donor - The donor entity providing the items for delivery.
 * @param {Entity} recipient - The recipient entity receiving the items.
 * @param {Delivery} delivery - The delivery details including time windows and identifiers.
 * @returns {DODOOrder} The created DODOOrder object containing all necessary delivery information.
 */
function createDodoOrderFromDelivery(
  entityPair: EntityPair,
  donor: Entity,
  recipient: Entity,
  delivery: Delivery
): DODOOrder {
  const deliveryIdentifier = delivery.deliveryIdentifier

  return {
    id: deliveryIdentifier,
    pickupDodoId: entityPair.carrierDonorId,
    pickupId: donor.establishmentId,
    pickupTo: delivery.pickupTimeWindow.end.toDate(),
    pickupFrom: delivery.pickupTimeWindow.start.toDate(),
    pickupNote: updateNoteWithWithPhoneNumbers(
      donor.noteForDriver || '',
      donor.phone,
      recipient.phone
    ),
    deliverAddress: `${recipient.street} ${recipient.houseNumber} ${recipient.city} ${recipient.postalCode}`,
    deliverId: recipient.establishmentId,
    deliverTo: delivery.deliveryTimeWindow.end.toDate(),
    deliverFrom: delivery.deliveryTimeWindow.start.toDate(),
    deliverNote: updateNoteWithWithPhoneNumbers(
      recipient.noteForDriver || '',
      donor.phone,
      recipient.phone
    ),
    customerName: recipient.responsiblePerson,
    customerPhone: recipient.phone
  }
}

// Optimization - lazy fetch
let cachedEntityPairs: EntityPair[] | null = null
let cachedEntities: Entity[] | null = null

/**
 * Fetches entity pairs and entities from Firestore if they are not already cached.
 *
 * @param logNumber - A number used for logging purposes to identify the fetch operation.
 *
 * @remarks
 * This function checks if `cachedEntityPairs` and `cachedEntities` are null. If they are,
 * it fetches the data from Firestore and caches them. The function logs the fetch operation
 * using the provided `logNumber`.
 *
 * @returns A promise that resolves when the entities have been fetched and cached.
 */
const fetchEntities = async (logNumber: number) => {
  if (cachedEntityPairs === null) {
    logDebug(`|${logNumber}| Fetching entityPairs`)
    cachedEntityPairs = await getEntityPairs(firestore)
  }

  if (cachedEntities === null) {
    logDebug(`|${logNumber}| Fetching entities`)
    cachedEntities = await getEntities(firestore)
  }
}
