const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, query, where, deleteDoc } = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword } = require('firebase/auth');

// ******
// Values
// ******

const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

// User credentials setup
const email = process.env.FIREBASE_REPORT_USER_EMAIL;
const password = process.env.FIREBASE_REPORT_USER_PASSWORD;

// Script timeout so the job will not run for long time when problem occurs
const timeout = setTimeout(() => {
  console.error('Script timed out');
  process.exit(1);
}, 10 * 60 * 1000); // 10 minutes

// *********
// Functions
// *********

async function signInAndCreateReport(email, password, startDate, endDate, donorId, recipientId) {
  try {
    // Sign in the user
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    console.info('User signed in: ', userCredential.user.uid);

    // Clear the reports collection
    await clearCollection('reports');
    console.info('Cleared reports collection');

    // Fetch and process documents
    const processedDocuments = await fetchAndProcessDocuments("deliveries", "reports", startDate, endDate, donorId, recipientId);
    console.info(`Fetched ${processedDocuments.length} delivery documents`);

    // Clear timeout on successful execution
    clearTimeout(timeout);
    process.exit(0);
  } catch (error) {
    console.error('`signInAndCreateReport` Function failed with following error: ', error);
    process.exit(1);
  }
}

async function clearCollection(collectionName) {
  try {
    const collectionRef = collection(db, collectionName);
    const snapshot = await getDocs(collectionRef);

    const deletePromises = snapshot.docs.map(docSnapshot => deleteDoc(docSnapshot.ref));
    await Promise.all(deletePromises);
    console.info(`Cleared ${snapshot.size} documents from ${collectionName} collection`);
  } catch (error) {
    console.error('`clearCollection` Function failed with following error: ', error);
    throw error;
  }
}

async function fetchAndProcessDocuments(fromCollectionName, toCollectionName, startDate, endDate, donorId, recipientId) {
  try {
    console.info(`Fetching deliveries for period ${startDate.toISOString()} - ${endDate.toISOString()}`);

    let filters = [
      where('deliveryDate', '>=', startDate),
      where('deliveryDate', '<', endDate)
    ];
    if (donorId) {
      filters.push(where('donorId', '==', donorId));
    }
    if (recipientId) {
      filters.push(where('recipientId', '==', recipientId));
    }

    const collectionRef = collection(db, fromCollectionName);
    const filteredQuery = query(collectionRef, ...filters);
    const snapshot = await getDocs(filteredQuery);

    const processedDocuments = [];

    for (const docSnapshot of snapshot.docs) {
      const data = docSnapshot.data();
      if (data.type === 'FOOD_DELIVERY' && data.meals?.length) {
        for (const meal of data.meals) {
          const mealDetails = await getMealDetails(meal.mealId);
          const mealDocument = {
            deliveryDate: data.deliveryDate,
            donorId: data.donorId,
            recipientId: data.recipientId,
            mealCount: meal.count,
            mealName: mealDetails.name,
            foodCategory: mealDetails.foodCategory
          };

          // Create document
          const reportDocId = `${docSnapshot.id}-${meal.mealId}`;
          const reportDocRef = doc(db, toCollectionName, reportDocId);
          await setDoc(reportDocRef, mealDocument, { merge: true });

          processedDocuments.push(mealDocument);
        }
      }
    }

    return processedDocuments;
  } catch (error) {
    console.error('`fetchAndProcessDocuments` Function failed with following error: ', error);
    return [];
  }
}

async function getMealDetails(mealId) {
  // Fetch meal names for each mealId in the meals array
  const mealDocRef = doc(db, "meals", mealId);
  const mealDocSnapshot = await getDoc(mealDocRef);

  if (mealDocSnapshot.exists()) {
    const mealData = mealDocSnapshot.data();
    return {
      name: mealData.name,
      foodCategory: mealData.foodCategory
    };
  } else {
    console.error("`fetchAndProcessDocuments` Function failed because no document was found for meal id ", mealId, ". Returning NotFound as a meal name and category.");
    return `NotFound(${mealId})`;
    return {
      name: `NotFound(${mealId})`,
      foodCategory: `NotFound(${mealId})`
    };
  }
}

// **************
// Function calls
// **************

// Take period string from environment
const targetPeriod = process.env.TARGET_PERIOD;
const startDate = process.env.START_DATE;
const endDate = process.env.END_DATE;
const donorId = process.env.DONOR_ID;
const recipientId = process.env.RECIPIENT_ID;

// If TARGET_PERIOD is provided, it takes precedence over START_DATE and END_DATE
let start, end;
if (targetPeriod) {
  const [year, month] = targetPeriod.split('-').map(Number);
  start = new Date(year, (month || 1) - 1, 1);
  end = new Date(year, (month || 12), 0, 23, 59, 59);
} else {
  if (startDate) {
    const [year, month, day] = startDate.split('-').map(Number);
    start = new Date(year, month - 1, day);
  }
  if (endDate) {
    const [year, month, day] = endDate.split('-').map(Number);
    end = new Date(year, month - 1, day, 23, 59, 59);
  }
}

signInAndCreateReport(email, password, start, end, donorId, recipientId);
