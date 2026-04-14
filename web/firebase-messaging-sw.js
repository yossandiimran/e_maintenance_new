// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
  apiKey: 'AIzaSyBvtfyVWHC5ukTXACmfYj0_7lQQPqXYdyo',
  appId: '1:743489091314:web:REPLACE_WITH_WEB_APP_ID',
  messagingSenderId: '743489091314',
  projectId: 'master-data-graha',
  authDomain: 'master-data-graha.firebaseapp.com',
  storageBucket: 'master-data-graha.appspot.com',
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();

// Optional: handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here if needed
  // const notificationTitle = payload.notification.title;
  // const notificationOptions = { body: payload.notification.body };
  // return self.registration.showNotification(notificationTitle, notificationOptions);
});
