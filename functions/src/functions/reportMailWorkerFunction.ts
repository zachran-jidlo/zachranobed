import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { currentServiceAccount } from "../config/firebase";
import { REPORT_MAIL } from "../config/constants";
import {
  findReportMailFailures,
  retryReportMail,
  writeReportMail,
} from "../services/reportMailService";
import {
  scheduleReportMailRetry,
  scheduleReportMailSweep,
} from "../services/cloudTaskService";

/**
 * Cloud Task worker that handles one paced mail operation.
 *
 * With a mailId it moves that mail back to RETRY so the extension resends it.
 * Otherwise it writes a fresh report mail. Either way it is one operation per
 * task, and the pacing comes from the staggered schedule time of the tasks.
 *
 * Auth: IAM invoker policy — only the Cloud Tasks service account can call it.
 */
export const reportMailSendHandler = onRequest(
  { invoker: currentServiceAccount },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).send("Method Not Allowed");
      return;
    }

    const { runId, to, message, mailId } = req.body ?? {};

    try {
      if (mailId) {
        await retryReportMail(mailId);
      } else if (runId && to && message) {
        await writeReportMail(runId, { to, message });
      } else {
        logger.warn("reportMailSendHandler: missing fields", req.body);
        res.status(400).json({ error: "Missing required fields" });
        return;
      }
      res.status(200).json({ ok: true });
    } catch (error) {
      logger.error("reportMailSendHandler: error", error);
      // Return 500 so Cloud Tasks retries this operation.
      res.status(500).json({ error: "Internal error" });
    }
  },
);

/**
 * Cloud Task worker that retries the failed report emails of a run.
 *
 * It reads the delivery state the extension wrote back on each mail of the
 * run. Failures under the attempt limit get a fresh, paced resend. Failures
 * that hit the limit are given up on. If anything was retried, the next sweep
 * is scheduled one retry delay after the last resend.
 *
 * Auth: IAM invoker policy — only the Cloud Tasks service account can call it.
 */
export const reportMailSweepHandler = onRequest(
  { invoker: currentServiceAccount },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).send("Method Not Allowed");
      return;
    }

    const { runId } = req.body ?? {};
    if (!runId) {
      logger.warn("reportMailSweepHandler: missing runId", req.body);
      res.status(400).json({ error: "Missing required field: runId" });
      return;
    }

    try {
      const failures = await findReportMailFailures(runId);

      let retried = 0;
      let exhausted = 0;
      for (const failure of failures) {
        if (failure.attempts >= REPORT_MAIL.MAX_ATTEMPTS) {
          exhausted++;
          logger.error(
            `reportMailSweep: giving up on mail ${failure.mailId} (run ${runId}) after ${failure.attempts} attempts`,
          );
          continue;
        }

        await scheduleReportMailRetry(
          failure.mailId,
          retried * REPORT_MAIL.SEND_INTERVAL_SECONDS,
        );
        retried++;
      }

      if (retried > 0) {
        // Resends were paced over retried * interval seconds. Sweep again one
        // retry delay after the last one goes out.
        await scheduleReportMailSweep(
          runId,
          retried * REPORT_MAIL.SEND_INTERVAL_SECONDS + REPORT_MAIL.RETRY_DELAY_SECONDS,
        );
      }

      logger.info(
        `reportMailSweep: run ${runId} retried=${retried} exhausted=${exhausted} failures=${failures.length}`,
      );
      res.status(200).json({ retried, exhausted });
    } catch (error) {
      logger.error(`reportMailSweepHandler: error for run ${runId}`, error);
      // Return 500 so Cloud Tasks retries the sweep.
      res.status(500).json({ error: "Internal error" });
    }
  },
);
