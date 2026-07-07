// Import functions
import { notifyCharityAboutDonationV2 } from "./functions/notifications/foodDeliveryFunction";
import { notifyCanteenAboutBoxShippmentV2 } from "./functions/notifications/boxReturnFunction";
import { boxesMismatchNotification } from "./functions/mismatchFunction";
import { monthlyBoxCheckupFunction } from "./functions/notifications/monthlyBoxCheckupFunction";
import { notifyCanteenAboutMissingMealInfo } from "./functions/notifications/missingMealInfoFunction";
import { notifyCanteenAboutCourierIncoming } from "./functions/notifications/canteenCourierIncomingFunction";
import { notifyCharityAboutCourierIncoming } from "./functions/notifications/charityCourierIncomingFunction";
import { sendOrdersFunction, sendOrders } from "./functions/sendOrdersFunction";
import { dodoOrderStatus } from "./functions/dodoOrderStatusFunction";
import { cloudTaskHandler } from "./functions/cloudTaskHandlerFunction";
import { boxDeliveryCreated } from "./functions/boxDeliveryCreatedFunction";
import { confirmationReminderHandler } from "./functions/notifications/confirmationReminderFunction";
import { boxTransfer } from "./functions/boxTransferFunction";
import {
  finalizeDeliveriesFunction,
  finalizeDeliveries,
} from "./functions/finalizeDeliveriesFunction";
import {
  createReportFunction,
  createReport,
  parsePeriod,
  ReportPeriod,
} from "./functions/createReportFunction";
import { orderDeliveryService } from "./functions/orderDeliveryServiceFunction";
import { syncDonationsToSheet } from "./functions/syncDonationsToSheetFunction";
import { onRequest } from "firebase-functions/v2/https";
import { ENVIRONMENTS, TIMEZONE } from "./config/constants";
import { reportTriggerToken, sheetsServiceAccountKey } from "./config/firebase";
import { DateTime } from "luxon";
import { clearEntityCache, getEntities } from "./services/entityService";

// Export for Firebase Functions (CommonJS style)
exports.notifyCharityAboutDonationV2 = notifyCharityAboutDonationV2;
exports.notifyCanteenAboutBoxShippmentV2 = notifyCanteenAboutBoxShippmentV2;
exports.boxesMismatchNotification = boxesMismatchNotification;
exports.monthlyBoxCheckupFunction = monthlyBoxCheckupFunction;
exports.notifyCanteenAboutMissingMealInfo = notifyCanteenAboutMissingMealInfo;
exports.notifyCanteenAboutCourierIncoming = notifyCanteenAboutCourierIncoming;
exports.notifyCharityAboutCourierIncoming = notifyCharityAboutCourierIncoming;

// Get current project ID
const currentProjectId =
  process.env.GCLOUD_PROJECT || process.env.FIREBASE_PROJECT_ID;

// DEV ONLY: Manual HTTP triggers for testing scheduled functions
if (currentProjectId === ENVIRONMENTS.DEV) {
  exports.triggerSendOrders = onRequest(async (req, res) => {
    try {
      let deliveryDate: Date | undefined;

      // Parse date from query parameter or request body
      const dateStr = (req.query.date as string) || req.body?.date;

      if (dateStr) {
        // Parse date string in format YYYY-MM-DD
        const parsed = DateTime.fromISO(dateStr, { zone: TIMEZONE });

        if (!parsed.isValid) {
          res.status(400).json({
            status: "error",
            message: `Invalid date format. Use YYYY-MM-DD format. Error: ${parsed.invalidReason}`,
          });
          return;
        }

        deliveryDate = parsed.startOf("day").toJSDate();
      }

      await sendOrders(deliveryDate);

      res.json({
        status: "success",
        message: `sendOrders executed successfully${dateStr ? ` for date ${dateStr}` : ""}`,
      });
    } catch (error) {
      res.status(500).json({
        status: "error",
        message: error instanceof Error ? error.message : "Unknown error",
      });
    }
  });

  exports.triggerFinalizeDeliveries = onRequest(async (req, res) => {
    try {
      const dateStr = (req.query.date as string) || req.body?.date;
      let date: Date | undefined;

      if (dateStr) {
        const parsed = DateTime.fromISO(dateStr, { zone: TIMEZONE });
        if (!parsed.isValid) {
          res.status(400).json({
            status: "error",
            message: `Invalid date format. Use YYYY-MM-DD. Error: ${parsed.invalidReason}`,
          });
          return;
        }
        date = parsed.startOf("day").toJSDate();
      }

      await finalizeDeliveries(date);
      res.json({
        status: "success",
        message: `finalizeDeliveries executed successfully${dateStr ? ` for date ${dateStr}` : ""}`,
      });
    } catch (error) {
      res.status(500).json({
        status: "error",
        message: error instanceof Error ? error.message : "Unknown error",
      });
    }
  });

}

// Manual report trigger, available in all environments.
// Requires the REPORT_TRIGGER_TOKEN secret as a bearer token.
// Params:
//   period   - YYYY-MM (one month) or YYYY (whole year).
//              Defaults to the previous calendar month.
//   entityId - send only this entity's report. The entity must have
//              reporting enabled, otherwise 409 is returned.
exports.triggerCreateReport = onRequest(
  {
    // IAM gate: allow anyone to reach the function.
    // Authorization is handled in-code via reportTriggerToken.
    invoker: "public",
    secrets: [reportTriggerToken],
  },
  async (req, res) => {
  const authHeader = req.headers.authorization;
  if (
    !authHeader?.startsWith("Bearer ") ||
    authHeader.split(" ")[1] !== reportTriggerToken.value()
  ) {
    res.status(401).json({
      status: "error",
      message: "Unauthorized",
    });
    return;
  }

  try {
    const periodStr = (req.query.period as string) || req.body?.period;
    const entityId = (req.query.entityId as string) || req.body?.entityId;

    let period: ReportPeriod | undefined;
    if (periodStr) {
      const parsed = parsePeriod(periodStr);
      if (!parsed) {
        res.status(400).json({
          status: "error",
          message: "Invalid period. Use YYYY-MM for a month or YYYY for a year.",
        });
        return;
      }
      period = parsed;
    }

    if (entityId) {
      const entities = await getEntities();
      const entity = entities.find((e) => e.id === entityId);
      if (!entity) {
        clearEntityCache();
        res.status(404).json({
          status: "error",
          message: `Entity ${entityId} not found`,
        });
        return;
      }
      if (!entity.reporting?.enabled || entity.reporting.emails.length === 0) {
        clearEntityCache();
        res.status(409).json({
          status: "error",
          message: `Entity ${entityId} has reporting disabled or no report emails configured`,
        });
        return;
      }
    }

    const stats = await createReport({ period, entityId });
    res.json({
      status: "success",
      ...stats,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error instanceof Error ? error.message : "Unknown error",
    });
  }
  },
);

// Manual donation sheet sync, available in all environments.
// Requires the REPORT_TRIGGER_TOKEN secret as a bearer token.
// Params:
//   date       - YYYY-MM-DD, sync one day. Defaults to yesterday.
//   from + to   - YYYY-MM-DD range (inclusive), backfill many days.
exports.triggerSyncDonationsToSheet = onRequest(
  {
    invoker: "public",
    secrets: [reportTriggerToken, sheetsServiceAccountKey],
    timeoutSeconds: 540,
  },
  async (req, res) => {
    const authHeader = req.headers.authorization;
    if (
      !authHeader?.startsWith("Bearer ") ||
      authHeader.split(" ")[1] !== reportTriggerToken.value()
    ) {
      res.status(401).json({ status: "error", message: "Unauthorized" });
      return;
    }

    const parseDay = (value: string): DateTime | null => {
      const parsed = DateTime.fromISO(value, { zone: TIMEZONE });
      return parsed.isValid ? parsed.startOf("day") : null;
    };

    try {
      const dateStr = (req.query.date as string) || req.body?.date;
      const fromStr = (req.query.from as string) || req.body?.from;
      const toStr = (req.query.to as string) || req.body?.to;

      // Range backfill.
      if (fromStr || toStr) {
        const from = fromStr ? parseDay(fromStr) : null;
        const to = toStr ? parseDay(toStr) : null;
        if (!from || !to) {
          res.status(400).json({
            status: "error",
            message: "Invalid range. Use from=YYYY-MM-DD&to=YYYY-MM-DD.",
          });
          return;
        }
        const days = to.diff(from, "days").days;
        if (days < 0 || days > 366) {
          res.status(400).json({
            status: "error",
            message: "Range must be forward and at most 366 days.",
          });
          return;
        }
        const results = [];
        for (let d = from; d <= to; d = d.plus({ days: 1 })) {
          if (results.length > 0) {
            // Stay under the Sheets per-minute write quota during backfill.
            await new Promise((resolve) => setTimeout(resolve, 1100));
          }
          results.push(await syncDonationsToSheet(d.toJSDate()));
        }
        res.json({ status: "success", days: results.length, results });
        return;
      }

      // Single day (or yesterday by default).
      let date: Date | undefined;
      if (dateStr) {
        const parsed = parseDay(dateStr);
        if (!parsed) {
          res.status(400).json({
            status: "error",
            message: "Invalid date. Use YYYY-MM-DD.",
          });
          return;
        }
        date = parsed.toJSDate();
      }
      const stats = await syncDonationsToSheet(date);
      res.json({ status: "success", ...stats });
    } catch (error) {
      res.status(500).json({
        status: "error",
        message: error instanceof Error ? error.message : "Unknown error",
      });
    }
  },
);

// Export HTTP functions
// Exported unconditionally: Cloud Tasks invokes this in all environments
// (both DEV and PROD create tasks that need this endpoint).
exports.cloudTaskHandler = cloudTaskHandler;
exports.confirmationReminderHandler = confirmationReminderHandler;

// Export Firestore triggers
exports.boxDeliveryCreated = boxDeliveryCreated;
exports.orderDeliveryService = orderDeliveryService;
exports.boxTransfer = boxTransfer;

// Export scheduled functions
exports.sendOrdersFunction = sendOrdersFunction;

// DODO webhook — URL: /orders/{identifier}/status
exports.orders = dodoOrderStatus;

exports.finalizeDeliveriesFunction = finalizeDeliveriesFunction;

exports.createReportFunction = createReportFunction;
