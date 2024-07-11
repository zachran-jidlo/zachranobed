const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, doc, setDoc, getDoc } = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword } = require('firebase/auth');

// Values
const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID
};

// User credentials setup
const email = process.env.FIREBASE_REPORT_USER_EMAIL;
const password = process.env.FIREBASE_REPORT_USER_PASSWORD;

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

const timeout = setTimeout(() => {
  console.error('Script timed out');
  process.exit(1);
}, 10 * 60 * 1000); // Set timeout to 10 minutes

// Functions

async function signInAndCreateReport(email, password, reportName) {
  try {
    // Sign in the user
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    console.log('User signed in:', userCredential.user.uid);

    // Fetch and sort documents by month and update reports collection
    const sortedDocuments = await fetchAndSortDocumentsByMonth("deliveries");
    console.log("The sorted deliveries are:", sortedDocuments);

    // Clear timeout on successful execution
    clearTimeout(timeout);
    process.exit(0);
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

async function fetchAndSortDocumentsByMonth(collectionName) {
  try {
    const collectionRef = collection(db, collectionName);
    const snapshot = await getDocs(collectionRef);

    const documentsByMonth = {};

    for (const docSnapshot of snapshot.docs) {
      const data = docSnapshot.data();
      const deliveryDate = data.deliveryDate.toDate(); // Convert Firestore Timestamp to JavaScript Date
      const yearMonth = `${deliveryDate.getFullYear()}-${String(deliveryDate.getMonth() + 1).padStart(2, '0')}`;

      if (!documentsByMonth[yearMonth]) {
        documentsByMonth[yearMonth] = {
          foodDeliveries: [],
          boxDeliveries: []
        };
      }

      if (data.type === 'FOOD_DELIVERY') {
        const mealsWithNames = data.meals ? await Promise.all(
          data.meals.map(async (meal) => {
            const mealName = await getMealName(meal.mealId);
            return {
              count: meal.count,
              name: mealName
            };
          })
        ) : [];

        documentsByMonth[yearMonth].foodDeliveries.push({
          id: docSnapshot.id,
          deliveryDate: data.deliveryDate,
          donorId: data.donorId,
          recipientId: data.recipientId,
          meals: mealsWithNames
        });
      } else if (data.type === 'BOX_DELIVERY') {
        const boxDelivery = {
          id: docSnapshot.id,
          deliveryDate: data.deliveryDate,
          donorId: data.donorId,
          recipientId: data.recipientId,
          foodBoxes: data.foodBoxes // Assuming this structure doesn't need modification
        };

        documentsByMonth[yearMonth].boxDeliveries.push(boxDelivery);
      }
    }

    // Create or update documents in the reports collection
    for (const [yearMonth, docs] of Object.entries(documentsByMonth)) {
      const reportDocRef = doc(db, "reports", `${yearMonth}-report`);
      await setDoc(reportDocRef, docs, { merge: true });
    }

    // Convert the object to an array of arrays for logging
    const sortedDocuments = Object.keys(documentsByMonth).map(month => documentsByMonth[month]);

    return sortedDocuments;
  } catch (error) {
    console.error("Error fetching documents: ", error);
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
    return "Not found";
  }
}

// Call the function with the desired name parameter
signInAndCreateReport(email, password, "Testing report 1");