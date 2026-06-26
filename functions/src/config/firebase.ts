import * as admin from "firebase-admin";
import { setGlobalOptions } from "firebase-functions/v2";
import { defineString, defineSecret } from "firebase-functions/params";
import { ENVIRONMENTS } from "./constants";

const currentProjectId =
  process.env.GCLOUD_PROJECT || process.env.FIREBASE_PROJECT_ID;

const SERVICE_ACCOUNTS: Record<string, string> = {
  [ENVIRONMENTS.DEV]:
    "firebase-adminsdk-ju14s@zachran-obed-dev.iam.gserviceaccount.com",
  [ENVIRONMENTS.PROD]:
    "firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com",
};

export const currentServiceAccount =
  SERVICE_ACCOUNTS[currentProjectId || ENVIRONMENTS.PROD];

setGlobalOptions({
  region: "europe-west1",
  serviceAccount: currentServiceAccount,
});

// Cloud Tasks config params
export const cloudTasksQueue = defineString("CLOUD_TASKS_QUEUE", { default: "delivery-state-transitions" });
export const cloudTasksLocation = defineString("CLOUD_TASKS_LOCATION", { default: "europe-west1" });

// DODO API secrets
export const dodoClientId = defineSecret("DODO_CLIENT_ID");
export const dodoClientSecret = defineSecret("DODO_CLIENT_SECRET");
export const dodoOauthUri = defineSecret("DODO_OAUTH_URI");
export const dodoScope = defineSecret("DODO_SCOPE");
export const dodoOrdersApi = defineSecret("DODO_ORDERS_API");
export const dodoWebhookToken = defineSecret("DODO_WEBHOOK_TOKEN");
export const externalApiAllowed = defineString("EXTERNAL_API_ALLOWED");

// Bearer token for the manual report trigger
export const reportTriggerToken = defineSecret("REPORT_TRIGGER_TOKEN");

admin.initializeApp();
export const db = admin.firestore();
