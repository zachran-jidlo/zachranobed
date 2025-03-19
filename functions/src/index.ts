// Deploy functions: firebase deploy --only functions
/* eslint-disable max-len */
import * as admin from "firebase-admin";
import {
  onDocumentCreated,
  onDocumentUpdated,
} from "firebase-functions/v2/firestore";
import { setGlobalOptions } from "firebase-functions/v2";

setGlobalOptions({
  region: "europe-west1",
  serviceAccount:
    "firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com",
});

admin.initializeApp();
const db = admin.firestore();

/**
 * Represents a food box.
 * @param {string} foodBoxId - The ID of the food box.
 * @param {string} count - The total count of the food box.
 * @param {string} donorCount - The count of donors for the food box.
 * @param {string} recipientCount - The count of recipients for the food box.
 */
class FoodBox {
  /**
   * Creates a new instance of the FoodBox class.
   * @param {string} foodBoxId - The ID of the food box.
   * @param {string} count - The total count of the food box.
   * @param {string} donorCount - The count of boxes at donor side.
   * @param {string} recipientCount - The count boxes at recipient side.
   */
  constructor(
    public foodBoxId: string,
    public count: number,
    public donorCount: number,
    public recipientCount: number
  ) {}
}

/**
 * Function triggered when a document in the "deliveries" collection is updated.
 * Notifies the charity about a donation if the delivery state is "ACCEPTED" and it's the current day.
 *
 * @param change - The change object containing the new and old data of the document.
 * @returns A Promise that resolves when the push notifications are sent.
 */
exports.notifyCharityAboutDonationV2 = onDocumentUpdated(
  "deliveries/{id}",
  (event) => {
    const newValue = event.data?.after?.data();
    const oldValue = event.data?.before?.data();

    // Not a valid state, do not continue with notification.
    if (!newValue || !oldValue) return null;

    if (
      (newValue.state === "ACCEPTED" || newValue.state === "NOT_USED") && // Filter out unnecesary loading from Firestore for other states
      newValue.state !== oldValue.state &&
      isToday(newValue.pickupTimeWindow.start.toDate())
    ) {
      const recipientId = newValue.recipientId;
      const donorId = newValue.donorId;

      return Promise.all([
        db.collection("entities").doc(recipientId).get(),
        db.collection("entities").doc(donorId).get(),
      ])
        .then((results) => {
          if (results[0].exists && results[1].exists) {
            const fcmTokens = results[0].data()!.fcmTokens;
            const donor = results[1].data();

            var title: string;
            var body: string;

            if (newValue.state === "ACCEPTED") {
              title = "Potvrzení darování";
              body = `${donor?.establishmentName} vám dnes daruje pokrmy.`;
            } else if (newValue.state === "NOT_USED") {
              title = "Dnes nezbylo jídlo";
              body = `V ${donor?.establishmentName} dnes nezbylo žádné jídlo.`;
            }

            // Create message for all tokens of given entity
            const messages = Object.values(fcmTokens).map((token) => {
              return {
                notification: {
                  title: title,
                  body: body,
                },
                token: token as string,
              };
            });

            return admin.messaging().sendEach(messages);
          } else {
            console.error(
              "Entity not found for recipientId:",
              recipientId,
              "or donorId:",
              donorId
            );
            return null;
          }
        })
        .then((response) => {
          console.info(
            "Successfully sent " + response?.successCount + " push messages."
          );
          // TODO: Go through success of each message and remove tokens that are not registered.
          // TODO: Thjere is a problem with messaging/mismatched-credential - token is from the app registered to diffrent Firebase project - DEV vs PROD.
        })
        .catch((error) => {
          console.error("Error sending push notification:", error);
          return null;
        });
    }

    return null;
  }
);

/**
 * Function triggered when there is an update in the "entityPairs" collection in foodboxes list.
 * It notifies a charity about the lack of boxes at a canteen.
 *
 * @param change - The change event that triggered the function.
 * @returns A promise that resolves when the notification is sent successfully.
 */
exports.notifyCharityAboutLackOfBoxesAtCanteenV2 = onDocumentUpdated(
  "entityPairs/{id}",
  (event) => {
    const newBoxes = event.data?.after?.data().foodboxes;
    const oldBoxes = event.data?.before?.data().foodboxes;

    const differenceMap: { [foodBoxId: string]: number } = {};
    newBoxes.forEach((newBox: FoodBox) => {
      const matchingOldBox = oldBoxes.find(
        (oldBox: FoodBox) => oldBox.foodBoxId === newBox.foodBoxId
      );
      if (matchingOldBox && newBox.donorCount < matchingOldBox.donorCount) {
        // TODO: Difference is used only for logging purposes. It can be deleted in future but leaving it here for now because of debugging.
        const difference = newBox.donorCount - matchingOldBox.donorCount;
        differenceMap[newBox.foodBoxId] = difference;
      }
    });

    // Stop if there are no changes
    if (Object.keys(differenceMap).length <= 0) {
      return null;
    }

    // TODO: Cache changes and send notification only once a day. Right now each change triggers a notification.

    const recipientId = event.data?.after?.data().recipientId;
    const donorId = event.data?.after?.data().donorId;

    return Promise.all([
      db.collection("entities").doc(recipientId).get(),
      db.collection("entities").doc(donorId).get(),
      db.collection("foodBoxes").get(),
    ])
      .then((results) => {
        const insufficentBoxes: string[] = [];

        // Create boxes array from insufficent boxes types
        Object.keys(differenceMap).forEach((foodBoxId: string) => {
          console.log(
            `Food box ${foodBoxId} has decreased by ${differenceMap[foodBoxId]}.`
          );

          if (
            newBoxes.find((box: FoodBox) => box.foodBoxId === foodBoxId)
              ?.donorCount >= 10
          ) {
            return;
          }

          results[2].docs
            .filter((doc) => doc.id === foodBoxId)
            .forEach((doc) => {
              const foodBox = doc.data();
              insufficentBoxes.push(foodBox.name);
            });
        });

        if (
          results[0].exists &&
          results[1].exists &&
          insufficentBoxes.length > 0
        ) {
          const fcmTokens = results[0].data()!.fcmTokens;
          const donor = results[1].data();

          const boxesString = insufficentBoxes.join(", ");

          // Create message for all tokens of given entity
          const messages = Object.values(fcmTokens).map((token) => {
            return {
              notification: {
                title: "Jídelně docházejí krabičky",
                body: `Prosím proveďte vratku krabiček typu "${boxesString}" do jídelny "${donor?.establishmentName}"`,
              },
              token: token as string,
            };
          });

          console.log(messages);

          return admin.messaging().sendEach(messages);
        } else {
          console.error("Entity not found for recipientId:", recipientId);
          return null;
        }
      })
      .then((response) => {
        console.info(
          "Successfully sent " + response?.successCount + " push messages."
        );
      })
      .catch((error) => {
        console.error("Error sending push notification:", error);
        return null;
      });
  }
);

/**
 * Is triggered when a document is created in the "deliveries" collection.
 * Notifies the canteen about the shipment of boxes.
 *
 * @param {admin.firestore.DocumentSnapshot} snapshot - The snapshot of the created delivery document.
 * @returns {Promise<any>} A promise that resolves when the notification is sent.
 */
exports.notifyCanteenAboutBoxShippmentV2 = onDocumentCreated(
  "deliveries/{id}",
  (event) => {
    const data = event.data;
    if (!data) {
      console.log("No data associated with the event");
      return;
    }
    const delivery = data.data();
    const donorId = delivery.donorId;

    if (delivery.type === "BOX_DELIVERY") {
      return db
        .collection("entities")
        .doc(donorId)
        .get()
        .then((entityDoc) => {
          if (entityDoc.exists) {
            const fcmTokens = entityDoc.data()!.fcmTokens;

            // Create message for all tokens of given entity
            const messages = Object.values(fcmTokens).map((token) => {
              return {
                notification: {
                  title: "Potvrzení svozu krabiček",
                  body: "Charita Vám vrací krabičky.",
                },
                token: token as string,
              };
            });

            return admin.messaging().sendEach(messages);
          } else {
            console.error("Entity not found for donorId:", donorId);
            return null;
          }
        })
        .then((response) => {
          console.info(
            "Successfully sent " + response?.successCount + " push messages."
          );
        })
        .catch((error) => {
          console.error("Error sending push notification:", error);
          return null;
        });
    }

    return null;
  }
);

exports.boxesMismatchNotification = onDocumentUpdated(
  "entityPairs/{entityPairId}",
  async (event) => {
    // Check if data exists and the specific field 'foodboxesCheckup' has been updated
    if (!event.data) {
      console.error("No data associated with the event");
      return;
    }

    const newValue = event.data.after.data();
    const oldValue = event.data.before.data();

    // Only respond to changes in the 'foodboxesCheckup' field
    if (newValue.foodboxesCheckup === oldValue.foodboxesCheckup) {
      console.info("'foodboxesCheckup' field has not been updated");
      return;
    }

    const oldDonorStatus = oldValue?.foodboxesCheckup?.donor?.status;
    const oldRecipientStatus = oldValue?.foodboxesCheckup?.recipient?.status;
    const newDonorStatus = newValue?.foodboxesCheckup?.donor?.status;
    const newRecipientStatus = newValue?.foodboxesCheckup?.recipient?.status;

    // DONOR
    if (newDonorStatus === "MISMATCH" && oldDonorStatus !== "MISMATCH") {
      console.info("Donor status is MISMATCH");

      await constructAndSendEmail(newValue.donorId, newValue, true);
    }

    // RECIPIENT
    if (
      newRecipientStatus === "MISMATCH" &&
      oldRecipientStatus !== "MISMATCH"
    ) {
      console.info("Recipient status is MISMATCH");

      await constructAndSendEmail(newValue.recipientId, newValue, false);
    }
  }
);

async function constructAndSendEmail(
  entityId: string,
  entityPair: admin.firestore.DocumentData,
  isDonor: boolean
): Promise<any> {
  const entity = (await db.collection("entities").doc(entityId).get()).data();

  if (!entity) {
    console.error(`Entity ${entity} does not exist`);
    return Promise.reject();
  }

  const foodboxesHtml = await constructFoodboxesCount(entityPair);

  const email = {
    to: [" marek.vimr@zachranjidlo.cz", "aplikace.zo@zachranjidlo.cz"],
    message: {
      subject: "Nesoulad při kontrole krabiček",
      html: `
<p>Ahoj,</p>

v rámci pravidelné kontroly stavu krabiček byl zjištěn nesoulad u těchto subjektů:

<ul>
    <li><strong>Uživatel:</strong> ${entity.establishmentName}</li>
    <li><strong>Role:</strong> ${isDonor ? "Dárce" : "Příjemce"}</li>
    <li><strong>Entity ID:</strong> ${entity.establishmentId}</li>
</ul>

Aktuální stav krabiček:
${foodboxesHtml}

<p><a href="https://rowy.app/p/zachran-obed/table/entityPairs">Zobrazit v aplikaci Rowy</a></p>

<p>Prosím o prověření této situace a případné kroky k jejímu vyřešení.</p>

<p>
Děkujeme,
<br>
<strong>Mobilní aplikace Zachraň oběd</strong>
</p>`,
    },
  };

  const mail = await db.collection("mails").add(email);

  if (!mail) {
    console.error("Mail could not be sent");
    return Promise.reject("Mail could not be sent");
  }

  return mail;
}

async function constructFoodboxesCount(
  entityPair: admin.firestore.DocumentData
): Promise<string> {
  const foodBoxNames = await db.collection("foodBoxes").get();
  const currentFoodBoxesState = entityPair.foodboxes;

  let foodBoxesHtml = "<ul>\n";
  currentFoodBoxesState.forEach((doc: FoodBox) => {
    const id = doc.foodBoxId;
    const count = doc.count;
    const donorCount = doc.donorCount;
    const recipientCount = doc.recipientCount;
    const foodBoxName = foodBoxNames.docs
      .find((doc) => doc.id === id)
      ?.data().name;
    foodBoxesHtml += `<li><strong>${foodBoxName}:</strong> ${count} (Dárce: ${donorCount}, Příjemce: ${recipientCount})</li>\n`;
  });
  foodBoxesHtml += "</ul>";
  return foodBoxesHtml;
}

/** Checks if the given date is today.
 * @param {Date} date - The date to check.
 * @return {Boolean} - True if the date is today, false otherwise.
 */
function isToday(date: Date): boolean {
  const today = new Date();
  return (
    date.getFullYear() === today.getFullYear() &&
    date.getMonth() === today.getMonth() &&
    date.getDate() === today.getDate()
  );
}
