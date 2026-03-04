import {logger} from "firebase-functions";
import {
  dodoClientId,
  dodoClientSecret,
  dodoOauthUri,
  dodoScope,
  dodoOrdersApi,
  externalApiAllowed,
} from "../config/firebase";
import {DodoToken, DodoTokenSchema, DodoOrder, Entity, EntityPair} from "../models";
import { Timestamp } from "firebase-admin/firestore";
import { getDateInFuture } from "../utils/dateUtils";
import { updateNoteWithPhoneNumbers } from "../utils/noteUtils";
import { BOX_RETURN_SCHEDULE, NOTE_PREFIXES } from "../config/constants";

interface CachedToken {
  token: DodoToken;
  expiresAt: number; // Unix ms
}

let tokenCache: CachedToken | null = null;
const TOKEN_EXPIRY_BUFFER_MS = 60_000; // Refresh 60s before actual expiry

/**
 * Get OAuth2 access token from DODO API.
 * Caches the token in memory and reuses it until 60s before expiry.
 * Returns fake token if EXTERNAL_API_ALLOWED is false.
 * @return {Promise<DodoToken>}
 */
export async function getDodoToken(): Promise<DodoToken> {
  const makeApiCalls = externalApiAllowed.value() === "true";

  if (!makeApiCalls) {
    logger.info("EXTERNAL_API_ALLOWED=false, returning fake DODO token");
    return {
      token_type: "Bearer",
      expires_in: 3600,
      ext_expires_in: 3600,
      access_token: "fake_token_for_testing",
    };
  }

  if (tokenCache && Date.now() < tokenCache.expiresAt - TOKEN_EXPIRY_BUFFER_MS) {
    logger.info("Reusing cached DODO oauth token");
    return tokenCache.token;
  }

  logger.info("Getting temporary DODO oauth token");

  // Build form-urlencoded body
  const params = new URLSearchParams();
  params.append("grant_type", "client_credentials");
  params.append("scope", dodoScope.value());
  params.append("client_id", dodoClientId.value());
  params.append("client_secret", dodoClientSecret.value());

  const response = await fetch(dodoOauthUri.value(), {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: params.toString(),
    signal: AbortSignal.timeout(30000),
  });

  if (!response.ok) {
    throw new Error(
      `DODO OAuth failed: ${response.status} ${response.statusText}`
    );
  }

  const data = await response.json();

  // Validate response against schema
  const result = DodoTokenSchema.safeParse(data);
  if (!result.success) {
    logger.error("Invalid DODO token response:", result.error);
    throw new Error("DODO API returned invalid token format");
  }

  logger.info(
    `Successfully received temporary DODO oauth token (expires in ${result.data.expires_in}s)`
  );

  tokenCache = {
    token: result.data,
    expiresAt: Date.now() + result.data.expires_in * 1000,
  };

  return result.data;
}

/**
 * Create a delivery order with DODO carrier service.
 * Skips API call if EXTERNAL_API_ALLOWED is false.
 * @param {DodoOrder} order - The order details
 * @param {DodoToken} token - The OAuth2 access token
 * @return {Promise<boolean>} True if order created successfully
 */
export async function createDodoOrder(
  order: DodoOrder,
  token: DodoToken
): Promise<boolean> {
  const makeApiCalls = externalApiAllowed.value() === "true";

  if (!makeApiCalls) {
    logger.info(
      `EXTERNAL_API_ALLOWED=false, skipping DODO order creation for ${order.id}`
    );
    return true; // Simulate success
  }

  logger.debug(`Creating DODO order for ${order.id}`);

  const payload = {
    Identifier: order.id,
    Pickup: {
      BranchIdentifier: order.pickupDodoId,
      RequiredStart: order.pickupFrom.toISOString(),
      RequiredEnd: order.pickupTo.toISOString(),
      Note: order.pickupNote,
    },
    Drop: {
      AddressRawValue: order.deliverAddress,
      RequiredStart: order.deliverFrom.toISOString(),
      RequiredEnd: order.deliverTo.toISOString(),
      Note: order.deliverNote,
    },
    CustomerName: order.customerName,
    CustomerPhone: order.customerPhone,
    Price: 0,
  };

  const response = await fetch(dodoOrdersApi.value(), {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${token.access_token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
    signal: AbortSignal.timeout(30000),
  });

  if (!response.ok) {
    const errorText = await response.text();
    logger.error(
      `DODO API returned non-success status: ${response.status}. Order ${order.id} creation failed. Response: ${errorText}`
    );
    return false;
  }

  logger.debug(`DODO order ${order.id} created successfully`);
  return true;
}

/**
 * Build a box return DODO order object from entity data and pre-calculated time windows.
 * Pickup is from the recipient (box donor), delivery is back to the donor (original sender).
 * @param {EntityPair} entityPair - The entity pair
 * @param {Entity} donor - The donor entity
 * @param {Entity} recipient - The recipient entity
 * @param {string} deliveryIdentifier - The delivery identifier
 * @return {DodoOrder} The box return order
 */
export function createBoxReturnOrder(
  entityPair: EntityPair,
  donor: Entity,
  recipient: Entity,
  deliveryIdentifier: string,
): DodoOrder {
  const pickupTimeWindow = {
    start: Timestamp.fromDate(
      getDateInFuture(1, BOX_RETURN_SCHEDULE.PICKUP.start),
    ),
    end: Timestamp.fromDate(getDateInFuture(1, BOX_RETURN_SCHEDULE.PICKUP.end)),
  };

  const deliveryTimeWindow = {
    start: Timestamp.fromDate(
      getDateInFuture(1, BOX_RETURN_SCHEDULE.DELIVERY.start),
    ),
    end: Timestamp.fromDate(
      getDateInFuture(1, BOX_RETURN_SCHEDULE.DELIVERY.end),
    ),
  };

  return {
    id: deliveryIdentifier,
    pickupDodoId: entityPair.carrierRecipientId,
    pickupId: recipient.establishmentId,
    pickupFrom: pickupTimeWindow.start.toDate(),
    pickupTo: pickupTimeWindow.end.toDate(),
    pickupNote:
      NOTE_PREFIXES.BOX_PICKUP +
      updateNoteWithPhoneNumbers(
        recipient.noteForDriver || "",
        recipient.phone,
        donor.phone,
      ),
    deliverId: donor.establishmentId,
    deliverAddress: `${donor.street} ${donor.houseNumber} ${donor.city} ${donor.postalCode}`,
    deliverFrom: deliveryTimeWindow.start.toDate(),
    deliverTo: deliveryTimeWindow.end.toDate(),
    deliverNote:
      NOTE_PREFIXES.BOX_DELIVERY +
      updateNoteWithPhoneNumbers(
        donor.noteForDriver || "",
        recipient.phone,
        donor.phone,
      ),
    customerName: donor.responsiblePerson,
    customerPhone: donor.phone,
  };
}
