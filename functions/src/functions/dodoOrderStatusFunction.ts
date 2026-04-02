import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import { dodoWebhookToken } from "../config/firebase";
import { updateDeliveryStateByDodoStatus } from "../services/deliveryService";

// Valid DODO order statuses
const VALID_STATUSES = [
  "OnWayToPickup",
  "ArrivedToPickup",
  "OnWayToCustomer",
  "ArrivedToCustomer",
  "Finished",
  "Refused",
] as const;

export const dodoOrderStatus = onRequest(
  {
    region: "europe-west1",
    cors: true,
    secrets: [dodoWebhookToken],
  },
  async (req, res) => {
    const T = "🚗";

    // Log every incoming request with full details
    logger.info(`${T} ➡️ incoming request`, {
      method: req.method,
      path: req.path,
      headers: {
        "content-type": req.headers["content-type"],
        authorization: req.headers.authorization ? "Basic ***" : undefined,
        "user-agent": req.headers["user-agent"],
        "x-forwarded-for": req.headers["x-forwarded-for"],
      },
      body: req.body,
    });

    const respond = (
      statusCode: number,
      body: { IsSuccess: boolean; Errors: string[] },
      context?: Record<string, unknown>,
    ): void => {
      const logData = { statusCode, ...body, ...context };
      if (body.IsSuccess) {
        logger.info(`${T} ✅ ${statusCode}`, logData);
      } else {
        logger.warn(`${T} ❌ ${statusCode}`, logData);
      }
      res.status(statusCode).json(body);
    };

    // 1. Validate HTTP method (PUT only)
    if (req.method !== "PUT") {
      respond(405, { IsSuccess: false, Errors: ["Method not allowed"] });
      return;
    }

    // 2. Parse URL path: req.path = "/{identifier}/status" or "/orders/{identifier}/status"
    // Firebase may include the function name prefix in req.path
    const rawParts = req.path.split("/").filter(Boolean);
    const pathParts = rawParts[0] === "orders" ? rawParts.slice(1) : rawParts;
    const identifier = pathParts[0];

    if (pathParts.length !== 2 || pathParts[1] !== "status") {
      respond(404, { IsSuccess: false, Errors: ["Not found"] });
      return;
    }

    // 3. Validate Basic auth header
    const authHeader = req.headers.authorization;
    if (
      !authHeader?.startsWith("Basic ") ||
      authHeader.split(" ")[1] !== dodoWebhookToken.value()
    ) {
      respond(
        401,
        { IsSuccess: false, Errors: ["Unauthorized"] },
        {
          identifier,
        },
      );
      return;
    }

    // 4. Validate request body
    const { OrderStatus } = req.body;
    if (!OrderStatus) {
      respond(
        400,
        { IsSuccess: false, Errors: ["Missing OrderStatus"] },
        {
          identifier,
        },
      );
      return;
    }

    if (!VALID_STATUSES.includes(OrderStatus)) {
      logger.warn(
        `${T} ⚠️ Unknown OrderStatus: ${OrderStatus} for ${identifier}`,
      );
      // Still accept it — don't break the integration over unknown statuses
    }

    // 5. Update Firestore delivery state based on DODO status
    const result = await updateDeliveryStateByDodoStatus(
      identifier,
      OrderStatus,
    );
    logger.info(
      `${T} 🔄 Updating delivery state for ${identifier} to ${OrderStatus}. Result: ${JSON.stringify(result)}`,
    );

    // 6. Return success
    respond(
      200,
      { IsSuccess: true, Errors: [] },
      {
        identifier,
        orderStatus: OrderStatus,
        // stateUpdate: result,
      },
    );
  },
);
