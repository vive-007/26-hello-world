const CACHE = 'hello-v1';
const ASSETS = [
  '/26-hello-world/hello.html',
  '/26-hello-world/manifest.webmanifest',
  '/26-hello-world/icon-192.png',
  '/26-hello-world/icon-512.png'
];
self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', (e) => { e.waitUntil(self.clients.claim()); });
self.addEventListener('fetch', (e) => {
  e.respondWith(caches.match(e.request).then((hit) => hit || fetch(e.request)));
});
