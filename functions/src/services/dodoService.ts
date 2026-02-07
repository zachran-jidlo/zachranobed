import {logger} from "firebase-functions";
import {
  dodoClientId,
  dodoClientSecret,
  dodoOauthUri,
  dodoScope,
  dodoOrdersApi,
  externalApiAllowed,
} from "../config/firebase";
import {DodoToken, DodoOrder} from "../models";

/**
 * Get OAuth2 access token from DODO API.
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
  logger.info(
    `Successfully received temporary DODO oauth token (expires in ${data.expires_in}s)`
  );

  return data as DodoToken;
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
