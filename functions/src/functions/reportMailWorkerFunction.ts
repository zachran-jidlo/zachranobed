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

    const { runId, round } = req.body ?? {};
    if (!runId || !round) {
      logger.warn("reportMailSweepHandler: missing fields", req.body);
      res.status(400).json({ error: "Missing required fields: runId, round" });
      return;
    }

    try {
      const failures = await findReportMailFailures(runId);

      // Resend each failure, paced. This is the (round + 1)-th attempt, since
      // the initial send was attempt 1.
      for (let i = 0; i < failures.length; i++) {
        await scheduleReportMailRetry(
          failures[i],
          i * REPORT_MAIL.SEND_INTERVAL_SECONDS,
        );
      }

      // Stop once the attempt cap is reached, so the run always ends even if
      // the extension never marks a mail SUCCESS (for example not configured).
      const isLastRound = round + 1 >= REPORT_MAIL.MAX_ATTEMPTS;
      if (failures.length > 0 && !isLastRound) {
        await scheduleReportMailSweep(
          runId,
          round + 1,
          failures.length * REPORT_MAIL.SEND_INTERVAL_SECONDS + REPORT_MAIL.RETRY_DELAY_SECONDS,
        );
      }

      logger.info(
        `reportMailSweep: run ${runId} round=${round} retried=${failures.length} lastRound=${isLastRound}`,
      );
      res.status(200).json({ round, retried: failures.length });
    } catch (error) {
      logger.error(`reportMailSweepHandler: error for run ${runId}`, error);
      // Return 500 so Cloud Tasks retries the sweep.
      res.status(500).json({ error: "Internal error" });
    }
  },
);
