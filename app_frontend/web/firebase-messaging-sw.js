// web/firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Your web app's Firebase configuration (same as index.html)
const firebaseConfig = {
  apiKey: "AIzaSyCT7twkCGudSOiePsgsSlsDZgWKHT3gxG8",
  authDomain: "full-stack-app-92e61.firebaseapp.com",
  projectId: "full-stack-app-92e61",
  storageBucket: "full-stack-app-92e61.firebasestorage.app",
  messagingSenderId: "33258933921",
  appId: "1:33258933921:web:ebf26cb174cc3f4f7ceae0",
  measurementId: "G-ZEBW21S3KF"
};

// Initialize Firebase in service worker
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

// Handle background messages (when app is not open)
messaging.onBackgroundMessage((payload) => {
  console.log('📨 Background message received:', payload);
  
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/favicon.png',
    badge: '/favicon.png',
    data: payload.data,
    requireInteraction: true,  // Notification stays until user interacts
    vibrate: [200, 100, 200],  // Vibration pattern
    sound: '/sound.mp3',  // Optional custom sound
    actions: [
      {
        action: 'open',
        title: 'View Order'
      },
      {
        action: 'dismiss',
        title: 'Dismiss'
      }
    ]
  };
  
  // Show notification
  self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click events
self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  
  const data = event.notification.data;
  const action = event.action;
  
  if (action === 'open' || !action) {
    // Open the app and navigate to order details
    event.waitUntil(
      clients.matchAll({ type: 'window', includeUncontrolled: true })
        .then((clientList) => {
          // If app is already open, focus on it
          for (const client of clientList) {
            if (client.url.includes('/') && 'focus' in client) {
              client.focus();
              // Send message to client to navigate
              client.postMessage({
                type: 'NAVIGATE_TO_ORDER',
                orderId: data?.orderId
              });
              return;
            }
          }
          // If app is not open, open it
          if (clients.openWindow) {
            return clients.openWindow('/');
          }
        })
    );
  }
});