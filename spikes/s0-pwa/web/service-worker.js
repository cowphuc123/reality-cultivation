const cacheName = 'reality-cultivation-s0-v1';
const assets = [
  './',
  './index.html',
  './style.css',
  './app.mjs',
  './manifest.json',
  '../core.mjs',
  '../../shared-spec/fixture/spike_v0_01.json',
];
self.addEventListener('install', (event) => {
  event.waitUntil(caches.open(cacheName).then((cache) => cache.addAll(assets)));
});
self.addEventListener('fetch', (event) => {
  event.respondWith(caches.match(event.request).then((cached) => cached ?? fetch(event.request)));
});
