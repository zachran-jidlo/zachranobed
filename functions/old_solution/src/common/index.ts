import admin from 'firebase-admin'
import { getFirestore } from 'firebase-admin/firestore'

import { config } from './config.js'

import { runChecks } from '../checkOrders/checkOrders.js'
import { sendDeliveries } from '../sendOrders/sendOrders.js'

const { privateKey } = JSON.parse(process.env.FIREBASE_PRIVATE_KEY ?? '')

const serviceAccount: admin.ServiceAccount = {
  privateKey,
  projectId: config.FIREBASE_PROJECT_ID,
  clientEmail: config.FIREBASE_CLIENT_EMAIL
}

export const app = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
})
export const firestore = getFirestore(app)

// await runChecks()
// await sendDeliveries()
