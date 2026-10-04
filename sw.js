// 41 Green Drive: keeps the app itself on the phone so it opens without a connection.
// Your data is not stored here (the app keeps its own saved copy); this only caches the page and its libraries.
const CACHE = "gd-shell-v2";
const SHELL = ["./", "./index.html", "./config.js", "./manifest.webmanifest", "./favicon.png", "./apple-touch-icon.png", "./icon-192.png", "./icon-512.png"];
const LIBS = /^https:\/\/(cdn\.jsdelivr\.net|cdnjs\.cloudflare\.com)\//;

self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE).then(c => Promise.all(SHELL.map(u => c.add(u).catch(() => {})))).then(() => self.skipWaiting()));
});
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => {
  const req = e.request; if (req.method !== "GET") return;
  const url = new URL(req.url);
  // the app's own files: always try the network first so updates show up, fall back to the saved copy
  if (url.origin === location.origin){
    e.respondWith(fetch(req).then(r => { if (r.ok){ const copy = r.clone(); caches.open(CACHE).then(c => c.put(req, copy)); } return r; })
      .catch(() => caches.match(req, {ignoreSearch: true}).then(r => r || caches.match("./index.html"))));
    return;
  }
  // libraries (Supabase, PDF tools): use the saved copy, refresh it in the background
  if (LIBS.test(req.url)){
    e.respondWith(caches.open(CACHE).then(async c => {
      const hit = await c.match(req);
      const net = fetch(req).then(r => { if (r.ok) c.put(req, r.clone()); return r; }).catch(() => hit);
      return hit || net;
    }));
  }
  // everything else (your data, photos, bill reading) goes straight to the network
});
