import { firestore } from '../common/index.js'
import { COLLECTIONS } from '../common/firestore.js'
import { logInfo, logError } from '../common/logger.js'

const BATCH_SIZE = 500

/**
 * Migration script to copy carrierId field value to boxReturnCarrierId field
 * for all EntityPair documents in Firestore.
 */
const migrateCarrierIdToBoxReturnCarrierId = async (): Promise<void> => {
  try {
    logInfo('Starting migration: copying carrierId to boxReturnCarrierId')

    // Get all EntityPair documents
    const snapshot = await firestore.collection(COLLECTIONS.ENTITY_PAIRS).get()

    logInfo(`Found ${snapshot.docs.length} EntityPair documents`)

    if (snapshot.empty) {
      logInfo('No documents to migrate')
      return
    }

    // Process documents in batches to avoid memory issues
    const batches = []
    let batch = firestore.batch()
    let batchCount = 0

    for (const doc of snapshot.docs) {
      const data = doc.data()
      const carrierId = data.carrierId

      if (!carrierId) {
        logError(`Document ${doc.id} missing carrierId field`, undefined)
        continue
      }

      // Update the document with boxReturnCarrierId
      batch.update(doc.ref, { boxReturnCarrierId: carrierId })
      batchCount++

      // If batch is full, add to batches array and start new batch
      if (batchCount >= BATCH_SIZE) {
        batches.push(batch)
        batch = firestore.batch()
        batchCount = 0
      }
    }

    // Add remaining batch if it has documents
    if (batchCount > 0) {
      batches.push(batch)
    }

    // Execute all batches
    let updatedCount = 0
    for (let i = 0; i < batches.length; i++) {
      await batches[i].commit()
      const batchSize =
        i === batches.length - 1 && batchCount > 0 ? batchCount : BATCH_SIZE
      updatedCount += batchSize
      logInfo(
        `Processed batch ${i + 1}/${batches.length} (${updatedCount}/${
          snapshot.docs.length
        } documents)`
      )
    }

    logInfo(
      `Migration completed successfully. Updated ${updatedCount} documents.`
    )
  } catch (error) {
    logError('Migration failed', error)
    process.exit(1)
  }
}

// Run the migration
migrateCarrierIdToBoxReturnCarrierId()
