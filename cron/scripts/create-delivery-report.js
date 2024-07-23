const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc, query, where, startAt, endAt } = require('firebase/firestore');
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

async function signInAndCreateReport(email, password, targetMonth) {
  try {
    // Sign in the user
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    console.info('User signed in: ', userCredential.user.uid);

    // Fetch and process documents
    const processedDocuments = await fetchAndProcessDocuments("deliveries", "reports", targetMonth);
    console.info(`Fetched ${processedDocuments.length} delivery documents`);

    // Clear timeout on successful execution
    clearTimeout(timeout);
    process.exit(0);
  } catch (error) {
    console.error('`signInAndCreateReport` Function failed with following error: ', error);
    process.exit(1);
  }
}

async function fetchAndProcessDocuments(fromCollectionName, toCollectionName, targetMonth) {
  try {
    const startDate = new Date(new Date().getFullYear(), targetMonth - 1, 1);
    const endDate = new Date(new Date().getFullYear(), targetMonth, 0, 23, 59, 59);

    const collectionRef = collection(db, fromCollectionName);
    const filteredQuery = query(
      collectionRef,
      where('deliveryDate', '>=', startDate),
      where('deliveryDate', '<=', endDate)
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
          const mealName = await getMealName(meal.mealId);
          const mealDocument = {
            deliveryDate: data.deliveryDate,
            donorId: data.donorId,
            mealCount: meal.count,
            mealName: mealName
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

async function getMealName(mealId) {
  // Fetch meal names for each mealId in the meals array
  const mealDocRef = doc(db, "meals", mealId);
  const mealDocSnapshot = await getDoc(mealDocRef);

  if (mealDocSnapshot.exists()) {
    const mealData = mealDocSnapshot.data();
    return mealData.name;
  } else {
    console.error("`fetchAndProcessDocuments` Function failed because no document was found for meal id ", mealId, ". Returning NotFound as a meal name.");
    return `NotFound(${mealId})`;
  }
}

// **************
// Function calls
// **************

// Take month integer from action argument
console.info("0 ", process.argv[0]);
console.info("1 ", process.argv[1]);
console.info("2 ", process.argv[2]);

const targetMonth = process.argv[2];

if (!targetMonth || targetMonth < 1 || targetMonth > 12) {
  console.error('No target month provided.');
  process.exit(1);
}

// Call your main function with the targetMonth argument
console.info(`Running script for target month: ${targetMonth}`);
signInAndCreateReport(email, password, targetMonth);