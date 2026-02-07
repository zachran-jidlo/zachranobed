import {db} from "../config/firebase";
import {Entity, EntityPair} from "../models";

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
  cachedEntities = snapshot.docs.map((doc) => ({
    ref: doc.ref,
    id: doc.id,
    ...doc.data(),
  })) as Entity[];

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
  const allPairs = snapshot.docs.map((doc) => ({
    ref: doc.ref,
    ...doc.data(),
  })) as EntityPair[];

  cachedEntityPairs = allPairs.filter(
    (pair) => pair.carrierId !== "disabled",
  );

  return cachedEntityPairs;
}
