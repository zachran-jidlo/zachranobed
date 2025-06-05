import * as admin from "firebase-admin";
import { setGlobalOptions } from "firebase-functions/v2";
import { defineString } from "firebase-functions/params";

setGlobalOptions({
  region: "europe-west1",
  serviceAccount:
    "firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com",
});

export const githubToken = defineString("GITHUB_TOKEN");

admin.initializeApp();
export const db = admin.firestore();
