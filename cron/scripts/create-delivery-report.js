const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, doc, setDoc } = require('firebase/firestore');
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

    snapshot.forEach(doc => {
      const data = doc.data();
      const deliveryDate = data.deliveryDate.toDate(); // Convert Firestore Timestamp to JavaScript Date
      const yearMonth = `${deliveryDate.getFullYear()}-${String(deliveryDate.getMonth() + 1).padStart(2, '0')}`;

      if (!documentsByMonth[yearMonth]) {
        documentsByMonth[yearMonth] = {
          foodDeliveries: [],
          boxDeliveries: []
        };
      }

      if (data.type === 'FOOD_DELIVERY') {
        documentsByMonth[yearMonth].foodDeliveries.push({ id: doc.id, ...data });
      } else if (data.type === 'BOX_DELIVERY') {
        documentsByMonth[yearMonth].boxDeliveries.push({ id: doc.id, ...data });
      }
    });

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

// Call the function with the desired name parameter
signInAndCreateReport(email, password, "Testing report 1");
