import * as admin from "firebase-admin";
import { setGlobalOptions } from "firebase-functions/v2";
import { defineString } from "firebase-functions/params";

setGlobalOptions({
  region: "europe-west1",
  serviceAccount:
    "firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com",
});

export const githubToken = defineString("GITHUB_TOKEN");

// DODO API secrets
export const dodoClientId = defineString("DODO_CLIENT_ID");
export const dodoClientSecret = defineString("DODO_CLIENT_SECRET");
export const dodoOauthUri = defineString("DODO_OAUTH_URI");
export const dodoScope = defineString("DODO_SCOPE");
export const dodoOrdersApi = defineString("DODO_ORDERS_API");

admin.initializeApp();
export const db = admin.firestore();
