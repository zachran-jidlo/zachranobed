const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, query, where, startAt, endAt, deleteDoc } = require('firebase/firestore');
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

async function signInAndCreateReport(email, password, targetPeriod) {
  try {
    // Sign in the user
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    console.info('User signed in: ', userCredential.user.uid);

    // Clear the reports collection
    await clearCollection('reports');
    console.info('Cleared reports collection');

    // Fetch and process documents
    const processedDocuments = await fetchAndProcessDocuments("deliveries", "reports", targetPeriod);
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

async function fetchAndProcessDocuments(fromCollectionName, toCollectionName, targetPeriod) {
  try {
    const [year, month] = targetPeriod.split('-').map(Number);
    const startDate = new Date(year, (month || 1) - 1, 1);
    const endDate = new Date(year, (month || 12), 0, 23, 59, 59);

    console.info(`Fetching deliveries for period ${startDate.toISOString()} - ${endDate.toISOString()}`);

    const collectionRef = collection(db, fromCollectionName);
    const filteredQuery = query(
      collectionRef,
      where('deliveryDate', '>=', startDate),
      where('deliveryDate', '<', endDate)
    );
    const snapshot = await getDocs(filteredQuery);

    const processedDocuments = [];

    for (const docSnapshot of snapshot.docs) {
      const data = docSnapshot.data();

      if (
        data.type === 'FOOD_DELIVERY' &&
        data.meals &&
        data.meals.length > 0
      ) {
        for (const meal of data.meals) {
          const mealDetails = await getMealDetails(meal.mealId);
          const mealDocument = {
            deliveryDate: data.deliveryDate,
            donorId: data.donorId,
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

if (!targetPeriod) {
  console.error('No target period provided.');
  process.exit(1);
}

// Call your main function with the targetPeriod argument
console.info(`Running script for period: ${targetPeriod}`);
signInAndCreateReport(email, password, targetPeriod);
