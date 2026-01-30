import * as admin from "firebase-admin";
import { setGlobalOptions } from "firebase-functions/v2";
import { defineString, defineSecret } from "firebase-functions/params";

setGlobalOptions({
  region: "europe-west1",
  serviceAccount:
    // "firebase-adminsdk-ju14s@zachran-obed-dev.iam.gserviceaccount.com",
    "firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com",
});

export const githubToken = defineString("GITHUB_TOKEN");

// DODO API secrets
export const dodoClientId = defineSecret("DODO_CLIENT_ID");
export const dodoClientSecret = defineSecret("DODO_CLIENT_SECRET");
export const dodoOauthUri = defineSecret("DODO_OAUTH_URI");
export const dodoScope = defineSecret("DODO_SCOPE");
export const dodoOrdersApi = defineSecret("DODO_ORDERS_API");
export const externalApiAllowed = defineString("EXTERNAL_API_ALLOWED");

admin.initializeApp();
export const db = admin.firestore();
