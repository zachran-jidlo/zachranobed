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

setGlobalOptions({
  region: "europe-west1",
  serviceAccount: SERVICE_ACCOUNTS[currentProjectId || ENVIRONMENTS.PROD],
});

export const githubToken = defineString("GITHUB_TOKEN");

// DODO API secrets
export const dodoClientId = defineSecret("DODO_CLIENT_ID");
export const dodoClientSecret = defineSecret("DODO_CLIENT_SECRET");
export const dodoOauthUri = defineSecret("DODO_OAUTH_URI");
export const dodoScope = defineSecret("DODO_SCOPE");
export const dodoOrdersApi = defineSecret("DODO_ORDERS_API");
export const dodoWebhookToken = defineSecret("DODO_WEBHOOK_TOKEN");
export const externalApiAllowed = defineString("EXTERNAL_API_ALLOWED");

admin.initializeApp();
export const db = admin.firestore();
