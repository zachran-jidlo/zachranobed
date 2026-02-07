import {db} from "../config/firebase";
import {Entity, EntitySchema, EntityPair, EntityPairSchema} from "../models";
import {logger} from "firebase-functions/v2";

// Lazy caching for entities and entity pairs (module-level variables)
let cachedEntities: Entity[] | null = null;
let cachedEntityPairs: EntityPair[] | null = null;

/**
 * Load all entities from Firestore (with lazy caching).
 * @return {Promise<Entity[]>} - Array of all entities
 */
export async function getEntities(): Promise<Entity[]> {
  if (cachedEntities !== null) {
    return cachedEntities;
  }

  const snapshot = await db.collection("entities").get();
  cachedEntities = snapshot.docs
    .map((doc) => {
      const result = EntitySchema.safeParse({
        ref: doc.ref,
        id: doc.id,
        ...doc.data(),
      });
      if (!result.success) {
        logger.warn(`Invalid entity document ${doc.id}:`, result.error);
        return null;
      }
      return result.data;
    })
    .filter((entity): entity is Entity => entity !== null);

  return cachedEntities;
}

/**
 * Load active entity pairs (carrierId != 'disabled').
 * @return {Promise<EntityPair[]>} - Array of active entity pairs
 */
export async function getEntityPairs(): Promise<EntityPair[]> {
  if (cachedEntityPairs !== null) {
    return cachedEntityPairs;
  }

  const snapshot = await db.collection("entityPairs").get();
  const allPairs = snapshot.docs
    .map((doc) => {
      const result = EntityPairSchema.safeParse({
        ref: doc.ref,
        ...doc.data(),
      });
      if (!result.success) {
        logger.warn(`Invalid entity pair document ${doc.id}:`, result.error);
        return null;
      }
      return result.data;
    })
    .filter((pair): pair is EntityPair => pair !== null);

  cachedEntityPairs = allPairs.filter(
    (pair) => pair.carrierId !== "disabled",
  );

  return cachedEntityPairs;
}
