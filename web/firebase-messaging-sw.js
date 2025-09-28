importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCf__cC3G9CzqSRK-HMeGaKzM-TD3Cg3uU',
  appId: '1:111193751758:web:c0dceb42e55b4ba09fd09f',
  messagingSenderId: '111193751758',
  projectId: 'i7y932',
  authDomain: 'i7y932.firebaseapp.com',
  storageBucket: 'i7y932.firebasestorage.app',
  measurementId: 'G-D0TQ048YN0',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const { title, body } = payload.notification ?? {};
  self.registration.showNotification(title ?? 'New content available', {
    body: body ?? 'Tap to explore the latest guidance.',
    data: payload.data ?? {},
    icon: '/icons/Icon-192.png',
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const target = event.notification?.data?.click_action || '/';
  event.waitUntil(self.clients.openWindow(target));
});
