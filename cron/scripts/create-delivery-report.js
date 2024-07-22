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

    // Fetch and process documents
    const processedDocuments = await fetchAndProcessDocuments("deliveries");
    console.log("The processed deliveries are:", processedDocuments);

    // Clear timeout on successful execution
    clearTimeout(timeout);
    process.exit(0);
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

async function fetchAndProcessDocuments(collectionName) {
  try {
    const collectionRef = collection(db, collectionName);
    const snapshot = await getDocs(collectionRef);

    const processedDocuments = [];

    for (const docSnapshot of snapshot.docs) {
      const data = docSnapshot.data();

      if (data.type === 'FOOD_DELIVERY' && data.meals) {
        for (const meal of data.meals) {
          const mealName = await getMealName(meal.mealId);
          const mealDocument = {
            deliveryId: docSnapshot.id,
            deliveryDate: data.deliveryDate,
            donorId: data.donorId,
            recipientId: data.recipientId,
            meal: {
              count: meal.count,
              name: mealName
            }
          };

          // Create document ID in the format "${deliveryId}-${mealId}"
          const reportDocId = `${docSnapshot.id}-${meal.mealId}`;
          const reportDocRef = doc(db, "reports", reportDocId);
          await setDoc(reportDocRef, mealDocument, { merge: true });

          processedDocuments.push(mealDocument);
        }
      }
    }

    return processedDocuments;
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
