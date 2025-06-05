import * as admin from "firebase-admin";
import { db } from "../config/firebase";
import { FoodBox } from "../models/FoodBox";

export async function constructAndSendEmail(
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
