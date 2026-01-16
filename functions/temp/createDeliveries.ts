import {
  COLLECTIONS,
  axiosLoggingEnabled,
  db,
  makeApiCalls,
  nodeEnvironment,
  getEntityPairs,
} from "../config/firebase";

const CREATED_DELIVERY_DAYS_IN_FUTURE = 1;

/**
 * Sends deliveries by loading entity pairs and entities from collections,
 * getting a temporary DODO oauth token, and handling the deliveries.
 * @returns {Promise<void>} A promise that resolves when the deliveries are sent successfully.
 */
export const sendDeliveries = async (): Promise<void> => {
  // Log some info about current configuration
  console.debug("===== Configuration info =====");
  console.debug(`Environment: ${nodeEnvironment.value()}`);
  console.debug(`Make API calls: ${makeApiCalls.value()}`);
  console.debug(`Axios logging enabled: ${axiosLoggingEnabled.value()}`);
  console.debug(`Timezone offset: ${new Date().getTimezoneOffset()} minutes`);
  console.debug("===== Configuration info =====");

  try {
    // Load entityPairs from entitiesPairs collection
    console.info(
      `Loading entity pair(s) from "${COLLECTIONS.ENTITY_PAIRS}" collection`
    );
    const entityPairs = await getEntityPairs(firestore);
    console.info(
      `Found ${entityPairs.length} entity pair(s) in "${COLLECTIONS.ENTITY_PAIRS}" collection`
    );

    // Load entities from entities collection
    console.info(`Loading entity(s) from "${COLLECTIONS.ENTITIES}" collection`);
    const entities = await getEntities(firestore);
    console.info(
      `Found ${entities.length} entity(s) in "${COLLECTIONS.ENTITIES}" collection`
    );

    console.info("Getting temporary DODO oauth token");
    let dodoToken: null | DodoToken = null;
    const dodoTokenResponse = await getDodoToken();

    if (config.MAKE_API_CALLS) {
      dodoToken = DodoTokenRT.check(dodoTokenResponse);
    }
    console.info(
      `Successfully received temporary DODO oauth token (expires in ${dodoToken?.expires_in}s)`
    );

    // Call handleDeliveries with entityPairs and entities
    const handledDeliveriesCount = await handleDeliveries(
      entityPairs,
      entities,
      dodoToken
    );
    if (!handledDeliveriesCount) {
      throw new Error("No deliveries have been handled");
    }
  } catch (error) {
    console.error("Script failed", error);
    process.exit(1);
  }
};
