/*const { initializeApp } = require('firebase/app');
const { getFirestore, collection, addDoc } = require('firebase/firestore');

// Firebase configuration
const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Function to create a new report
async function createReport(name) {
  try {
    const docRef = await addDoc(collection(db, 'reports'), { name: name });
    console.log('Document successfully written with ID: ', docRef.id);
  } catch (error) {
    console.error('Error writing document: ', error);
  }
}

// Call the function with the desired name parameter
createReport("Testing report 1");*/

console.log("Hello world");
