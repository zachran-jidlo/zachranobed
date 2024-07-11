const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, addDoc, doc, getDoc, setDoc } = require('firebase/firestore');
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

    // Create a new report
    // const docRef = await addDoc(collection(db, 'reports'), { name: reportName });
    // console.log('Document successfully written with ID: ', docRef.id);

    const test = await fetchAndSortDocumentsByMonth("deliveries");
    console.log("The sorted deliveries are:")
    console.log(test)

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
        documentsByMonth[yearMonth] = [];
      }

      documentsByMonth[yearMonth].push({ id: doc.id, ...data });
    });

    // Create new collections for each month and add or update documents
    for (const [yearMonth, docs] of Object.entries(documentsByMonth)) {
      const newCollectionName = `${yearMonth}-report`;
      for (const docData of docs) {
        const docRef = doc(db, newCollectionName, docData.id);

        // Use setDoc with merge: true to update the document if it exists, or create it if it doesn't
        await setDoc(docRef, docData, { merge: true });
      }
    }

    // Convert the object to an array of arrays
    const sortedDocuments = Object.keys(documentsByMonth).map(month => documentsByMonth[month]);

    return sortedDocuments;
  } catch (error) {
    console.error("Error fetching documents: ", error);
    return [];
  }
}

// Call the function with the desired name parameter
signInAndCreateReport(email, password, "Testing report 1");
