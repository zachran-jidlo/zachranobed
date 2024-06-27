const firebase = require('firebase/app');
require('firebase/firestore');

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
firebase.initializeApp(firebaseConfig);

const db = firebase.firestore();

// Function to create a new report
function createReport(name) {
  db.collection('reports').add({
    name: name
  }).then((docRef) => {
    console.log('Document successfully written with ID: ', docRef.id);
  }).catch(error => {
    console.error('Error writing document: ', error);
  });
}

// Call the function with the desired name parameter
createReport("Testing report 1");
