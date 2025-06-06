import { onSchedule } from "firebase-functions/v2/scheduler";
import { githubToken } from "../config/firebase";

// CET Timezone - 10:00 - 18:00 (CEST 11:00 - 19:00 - ideally change the setup to 8-16 in summer time) every 7-8 minutes
export const scheduledFunctionCrontab = onSchedule(
  "0,7,15,22,30,37,45,52 9-17 * * 1-5",
  async (event) => {
    console.log("Scheduled function invoked");

    // Trigger GitHub Action
    const response = await fetch(
      "https://api.github.com/repos/zachran-jidlo/zachran-obed-firebase-cron/actions/workflows/checkOrders.yml/dispatches",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${githubToken.value()}`,
          Accept: "application/vnd.github+json",
          "X-GitHub-Api-Version": "2022-11-28",
        },
        body: JSON.stringify({
          ref: "main",
        }),
      }
    );

    if (!response.ok) {
      console.error("Failed to trigger GitHub Action:", response.statusText);
      throw new Error(`GitHub API error: ${response.status}`);
    }

    console.log("GitHub Action triggered successfully");
  }
);
