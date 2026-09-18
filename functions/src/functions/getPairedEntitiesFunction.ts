import { onCall, HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { db } from "../config/firebase";

/**
 * A contact person as exposed to a paired counterparty.
 */
interface PairedContact {
  name: string;
  position: string | null;
  phoneNumber: string | null;
}

/**
 * The entity fields a paired counterparty is allowed to see.
 */
interface PairedEntity {
  id: string;
  establishmentName: string;
  responsiblePerson: string;
  responsiblePersonPosition: string | null;
  phone: string | null;
  additionalContacts: PairedContact[];
}

/**
 * Maps a stored contact to the whitelisted shape. Anything else the stored
 * contact happens to carry stays on the server.
 */
function toContacts(stored: unknown): PairedContact[] {
  if (!Array.isArray(stored)) {
    return [];
  }
  return stored.map((contact) => ({
    name: contact?.name ?? "",
    position: contact?.position ?? null,
    phoneNumber: contact?.phoneNumber ?? null,
  }));
}

/**
 * Returns the caller's own entity and the entities it is paired with.
 *
 * This exists so that clients never need read access to someone else's entity
 * document. Security rules cannot check pairing on their own. A pair is stored
 * under a generated document id and rules cannot run queries, so a rule has no
 * way to look the pair up. Here the pairing is checked with a normal query.
 *
 * The function takes no arguments. It reads the entity from the `entityId`
 * custom claim, so a caller cannot ask for a different entity.
 *
 * Only the fields listed in the mapping below are returned. The Admin SDK
 * ignores security rules, so this mapping is the only thing that limits what
 * leaves the server. A new field added to an entity stays hidden until it is
 * added here.
 */
export const getPairedEntities = onCall(async (request) => {
  const entityId = request.auth?.token.entityId as string | undefined;
  if (!entityId) {
    logger.warn("getPairedEntities called without an entityId claim", {
      uid: request.auth?.uid,
    });
    throw new HttpsError("permission-denied", "Missing entity claim");
  }

  const pairs = db.collection("entityPairs");
  const [asDonor, asRecipient] = await Promise.all([
    pairs.where("donorId", "==", entityId).get(),
    pairs.where("recipientId", "==", entityId).get(),
  ]);

  // The caller's own entity is included, the pair mapper on the client needs
  // both sides of every pair.
  const ids = new Set<string>([entityId]);
  const add = (id: unknown) => {
    if (typeof id === "string" && id.length > 0) {
      ids.add(id);
    }
  };
  asDonor.docs.forEach((doc) => add(doc.data().recipientId));
  asRecipient.docs.forEach((doc) => add(doc.data().donorId));

  const refs = [...ids].map((id) => db.collection("entities").doc(id));
  const docs = await db.getAll(...refs);

  const entities: PairedEntity[] = docs
    .filter((doc) => doc.exists)
    .map((doc) => {
      const data = doc.data() ?? {};
      return {
        id: doc.id,
        establishmentName: data.establishmentName ?? "",
        responsiblePerson: data.responsiblePerson ?? "",
        responsiblePersonPosition: data.responsiblePersonPosition ?? null,
        phone: data.phone ?? null,
        additionalContacts: toContacts(data.additionalContacts),
      };
    });

  return { entities };
});
