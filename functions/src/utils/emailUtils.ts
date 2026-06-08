import * as admin from "firebase-admin";
import { Timestamp } from "firebase-admin/firestore";
import { db } from "../config/firebase";
import { FoodBox } from "../models/FoodBox";
import { FoodBoxesCheckupReportedCount } from "../models/FoodBoxesCheckupReportedCount";

export async function constructAndSendEmail(
  entityId: string,
  entityPair: admin.firestore.DocumentData,
  isDonor: boolean,
  reportedCounts: FoodBoxesCheckupReportedCount[]
): Promise<any> {
  const entity = (await db.collection("entities").doc(entityId).get()).data();

  if (!entity) {
    console.error(`Entity ${entity} does not exist`);
    return Promise.reject(new Error(`Entity not found: ${entityId}`));
  }

  // Notify the opposite side of the pair so they can verify their own boxes
  const counterpartyId = isDonor ? entityPair.recipientId : entityPair.donorId;
  const counterparty = (await db.collection("entities").doc(counterpartyId).get()).data();

  const to = ["marek.vimr@zachranjidlo.cz", "aplikace.zo@zachranjidlo.cz"];
  if (counterparty?.email) {
    to.push(counterparty.email);
  } else {
    console.warn(`Counterparty ${counterpartyId} has no email, sending to admins only`);
  }

  const mismatches = reportedCounts.filter(
    (rc) => rc.systemCount !== rc.realCount
  );
  const hasReportedCounts = mismatches.length > 0;
  const foodboxesSectionTitle = hasReportedCounts ?
    "Nahlášený stav krabiček:" :
    "Aktuální stav krabiček:";
  const foodboxesHtml = hasReportedCounts ?
    await constructReportedCountsTable(mismatches) :
    await constructFoodboxesCount(entityPair);

  const email = {
    createdAt: Timestamp.now(),
    to,
    message: {
      subject: "Nesoulad při kontrole krabiček",
      html: `
  <p>Dobrý den,</p>

  v rámci pravidelné kontroly stavu krabiček byl zjištěn nesoulad u těchto subjektů:

  <ul>
      <li><strong>Uživatel:</strong> ${entity.establishmentName}</li>
      <li><strong>Role:</strong> ${isDonor ? "Dárce" : "Příjemce"}</li>
      <li><strong>Entity ID:</strong> ${entity.establishmentId}</li>
  </ul>

  ${foodboxesSectionTitle}
  ${foodboxesHtml}

  <p><strong>Zkontrolujte, prosím, aktuální stav krabiček na Vaší straně.</strong><br>
  Pokud neodpovídá údajům v aplikaci, kontaktujte koordinátora projektu.</p>

  <p>
  Děkujeme,
  <br>
  <strong>Tým projektu Zachraň oběd</strong>
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

async function constructReportedCountsTable(
  reportedCounts: FoodBoxesCheckupReportedCount[]
): Promise<string> {
  const foodBoxNames = await db.collection("foodBoxes").get();

  const cellStyle = "border:1px solid #ccc; padding:6px;";
  const rows = reportedCounts
    .map((rc) => {
      const foodBoxName = foodBoxNames.docs
        .find((doc) => doc.id === rc.foodBoxId)
        ?.data().name ?? rc.foodBoxId;
      return [
        "<tr>",
        `  <td style="${cellStyle}"><strong>${foodBoxName}</strong></td>`,
        `  <td style="${cellStyle}">${rc.systemCount}</td>`,
        `  <td style="${cellStyle}">${rc.realCount}</td>`,
        "</tr>",
      ].join("\n");
    })
    .join("\n");

  return [
    "<table style=\"border-collapse: collapse;\">",
    "  <thead>",
    "    <tr>",
    `      <th style="${cellStyle}">Krabička</th>`,
    `      <th style="${cellStyle}">Počet v systému</th>`,
    `      <th style="${cellStyle}">Reálný počet</th>`,
    "    </tr>",
    "  </thead>",
    "  <tbody>",
    rows,
    "  </tbody>",
    "</table>",
  ].join("\n");
}
