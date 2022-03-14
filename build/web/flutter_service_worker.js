'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "9dea5ad8010a4422fdd9d34453e40e9d",
"index.html": "247a672c25aba93a8943041bb84816d8",
"/": "247a672c25aba93a8943041bb84816d8",
"main.dart.js": "bfd949fa1a2729df9eaa02f2753838ae",
"favicon.png": "a50ea8f51b6f040d8c4d7ce124b8ca5d",
"icons/Icon-128.png": "6c7800e6ac5e61e1f29b1dfa9a5bf1d0",
"icons/Icon-512.png": "69577e755d07312e75ce52a636576527",
"manifest.json": "d194907fdc6e12df200d025cf8031327",
"assets/AssetManifest.json": "3b39289be993a816408b3904be67dc6f",
"assets/NOTICES": "e3d0cc83eb699586b6e5ac2c4e503338",
"assets/FontManifest.json": "4ba688a51f07d4ab46be44a3fc30bd68",
"assets/assets/images/symphony_no_40_4.svg": "bf60f0469e4712a7f7192fb4e3f9a5ad",
"assets/assets/images/symphony_no_40_5.svg": "2bae513031488246aba74f5da4d9e094",
"assets/assets/images/symphony_no_40_7.svg": "68aaac94cc64bb3b436242e2719f0f2a",
"assets/assets/images/symphony_no_5_8.svg": "6f58a970f14be42561c5941c201f8bc9",
"assets/assets/images/symphony_no_5_9.svg": "b50cc5ea8f891dfd1872a18e7dd82298",
"assets/assets/images/symphony_no_40_6.svg": "37d08c81a88d14dc16493c77c48fd1f1",
"assets/assets/images/symphony_no_40_2.svg": "cdb1aa0a565bdeb6f7499eeb3544b623",
"assets/assets/images/symphony_no_40_3.svg": "2c9408c4f97f44a48d67d18d09019e6a",
"assets/assets/images/symphony_no_40_1.svg": "9d091a27a98372cc430c9dba0fd43a00",
"assets/assets/images/symphony_no_40_0.svg": "5ff56e81154e8c92214f0697169799ed",
"assets/assets/images/symphony_no_5_2.svg": "88a1bb3fd42296784f70e4acd0bffb2d",
"assets/assets/images/symphony_no_5_13.svg": "79b508722d9d346c9ad7ef39457d4d63",
"assets/assets/images/symphony_no_5_12.svg": "7ef2ee755603fad2a08d49caf867fdf5",
"assets/assets/images/symphony_no_5_3.svg": "4da3b701028961825f1abfe640556817",
"assets/assets/images/symphony_no_5_1.svg": "1ee7ef28ee9631d6f8af2c516097700a",
"assets/assets/images/symphony_no_5_10.svg": "2135b38e4f73fe78e6d3ebda17b3094d",
"assets/assets/images/symphony_no_5_11.svg": "8c4891188e54911a3d043f6b5e140ffe",
"assets/assets/images/symphony_no_5_0.svg": "2d78b697a2cb353c307240e3462c889f",
"assets/assets/images/symphony_no_5_4.svg": "6af3d6c95ee11884818882dda73ccba9",
"assets/assets/images/symphony_no_5_14.svg": "62010edf2623ffc55210ad959d95596c",
"assets/assets/images/symphony_no_5_5.svg": "798d33831d9193fb7c5ece8bd18d2ee8",
"assets/assets/images/symphony_no_5_7.svg": "9fe2f6dff6a1219526492fc100b328cf",
"assets/assets/images/symphony_no_5_6.svg": "a01b0f870eb52e40a05771bf246acb88",
"assets/assets/languages/es.arb": "1d2c93455e6eefa2733da688466e76dc",
"assets/assets/languages/en.arb": "cd30f9cb2567b79a3d79dda1f9af08c6",
"assets/assets/sounds/move_effect.mp3": "f7642d4def16c74fbbe44d7d269e2596",
"assets/assets/sounds/shake_effect.mp3": "6d7a7c9af23e2013f35a30a044b93184",
"assets/assets/sounds/symphony_no_5_14.mp3": "53ce79312a693e32e68f5b72dfb0290f",
"assets/assets/sounds/symphony_no_5_5.mp3": "28e26c6e366fbfbff6a11b37d2f468ad",
"assets/assets/sounds/symphony_no_5_4.mp3": "902eb23a2aa14cd3dda2ee782f9ebcf2",
"assets/assets/sounds/onboarding.mp3": "c2de60d10cd4b2a164b3a3f34e92f961",
"assets/assets/sounds/symphony_no_5_6.mp3": "82a17e5e8887b7aff18cc13f3d5a9ef2",
"assets/assets/sounds/symphony_no_5_7.mp3": "008cc0f405ea8cdb8f38849c8b5e4993",
"assets/assets/sounds/symphony_no_5_12.mp3": "27cbd80b93bdfc0a87b36237612ec1f2",
"assets/assets/sounds/symphony_no_5_3.mp3": "08263f1904e73a7c7a9b5508b330d22a",
"assets/assets/sounds/symphony_no_5_2.mp3": "956fcbbecb3a4ee4ae67e556eb40f77e",
"assets/assets/sounds/symphony_no_5_13.mp3": "8157824ee9678fc6c57c3fee74942648",
"assets/assets/sounds/symphony_no_5_11.mp3": "facfa0b72961e99f32628c2a0f206d39",
"assets/assets/sounds/symphony_no_5_0.mp3": "1cbb70a01e119caae414c621241e5f64",
"assets/assets/sounds/symphony_no_5_1.mp3": "02b58277461f9ab8b3df0f597656afce",
"assets/assets/sounds/tap_effect.mp3": "7c25fae12bcfb860bd551fecb83dd218",
"assets/assets/sounds/symphony_no_5_10.mp3": "c30b17d3e34178c526023b3b2c9e7a55",
"assets/assets/sounds/symphony_no_40_3.mp3": "344828a286cbbecb24fceb58f125694e",
"assets/assets/sounds/symphony_no_40_2.mp3": "c069002549e81eaf360481a40a5ece0c",
"assets/assets/sounds/symphony_no_40_0.mp3": "baac94958ba3739c01e0d0ee1e8191a0",
"assets/assets/sounds/symphony_no_40_1.mp3": "3385ec24d85950d40f27b7a542ea508c",
"assets/assets/sounds/symphony_no_40_5.mp3": "4d563268702804cd371c4ec35dc818f1",
"assets/assets/sounds/symphony_no_40_4.mp3": "1d67dd9091b4c188c5cbf83f8fc33153",
"assets/assets/sounds/symphony_no_5_9.mp3": "263f08d93d57ca13b736211d473ea76c",
"assets/assets/sounds/symphony_no_40_6.mp3": "87f4da2228f254eb19590709d11cd890",
"assets/assets/sounds/symphony_no_40_7.mp3": "b69cc727bb4d690b0acef62df3d06e9c",
"assets/assets/sounds/symphony_no_5_8.mp3": "5314abe5f0f03806e27d513a74261e4a",
"assets/assets/sounds/close_book_effect.mp3": "df3e0f088cb62c9ab185ce2e8a39aa67",
"assets/assets/sounds/page_effect.mp3": "d4d2afd13147ec2e365a0cbc5498be33",
"assets/assets/icons/background.svg": "858c5c214635b2f1bba8ffc28ec3d229",
"assets/assets/icons/reset.svg": "3968e0b2d070f23bd708aa350360eff2",
"assets/assets/icons/natural.svg": "4dcfe8fd3208cb6aeea56f3ee51afcce",
"assets/assets/icons/finger.svg": "547506cab048b5365958853d7b385690",
"assets/assets/icons/semibreve.svg": "deda01d1b06d30cfeebdf4743f080813",
"assets/assets/icons/vibrate.svg": "3da5f2ddff9fdf188d7752c0703deebb",
"assets/assets/icons/settings.svg": "27c88b0193a77b9c184570fd3c0d6cd0",
"assets/assets/icons/flat.svg": "adae75b8c9e7003d811fa5a42be33e01",
"assets/assets/icons/crotchet.svg": "63d28e1bf751ee823b1622c0ec914368",
"assets/assets/icons/classical_music_puzzle.svg": "dd03dc50548d975c472061baedd26792",
"assets/assets/icons/trophy.svg": "b38c6c5ea3a29e4f213f2891e03edd2a",
"assets/assets/icons/check.svg": "5f2b5a5268c263ab3a031b5fe1cd4a13",
"assets/assets/icons/close.svg": "a63d48209e541981e04fd526dbf9d139",
"assets/assets/icons/english.svg": "ba8091896ea88accd3396426ec4bfc7b",
"assets/assets/icons/minim.svg": "fca6c1ea412fd2d5b79503e83073a399",
"assets/assets/icons/f_clef.svg": "e843f4081012a8c0f31ca52dcecfbe20",
"assets/assets/icons/g_clef.svg": "a4cf0e1de79d25fd8c64279c2963f3a2",
"assets/assets/icons/back.svg": "807e3ab99080c8ea90c64be00c26014e",
"assets/assets/icons/crotchet_rest.svg": "0d484ddde73bef9e4275c28fca087d4d",
"assets/assets/icons/fermata.svg": "6689736715428b59a9585be5d28553ae",
"assets/assets/icons/next.svg": "2ee6d9956ebf12858b97c5df376f17a0",
"assets/assets/icons/audio.svg": "6e31fa2f4dca6598067f427e9c9057df",
"assets/assets/icons/clock.svg": "32e1e3eebc8d10be515d2f21ac205ade",
"assets/assets/icons/mobile.svg": "62a6c781bc77ca76c4cb40467a109f11",
"assets/assets/icons/sharp.svg": "1d9efe241d91caa1cc57f0427bd1b6c9",
"assets/assets/icons/quaver.svg": "93d15f32a156f134fe9523642f39cfae",
"assets/assets/icons/quaver_rest.svg": "6ab10979e47a2801d20bf19543136dac",
"assets/assets/icons/spanish.svg": "1fb3a1b83e5c084123479108578a8b34",
"assets/assets/fonts/Times_New_Roman/Times_New_Roman_Italic.ttf": "e3d6e9ea74f51afbfc9071e214ddb9e8",
"assets/assets/fonts/Times_New_Roman/Times_New_Roman_Regular.ttf": "e2f6bf4ef7c6443cbb0ae33f1c1a9ccc",
"assets/assets/fonts/Times_New_Roman/Times_New_Roman_Bold.ttf": "1d3466fec8a99ed65f32cbdfb3d5c4d0",
"assets/assets/fonts/Times_New_Roman/Times_New_Roman_Bold_Italic.ttf": "85950e39e82115c6eab24d91fc1b7723",
"assets/assets/fonts/Open_Sans/Open_Sans_Medium_Italic.ttf": "af8809ff3bd655a62950c8e21361695f",
"assets/assets/fonts/Open_Sans/Open_Sans_Italic.ttf": "07cd1acf656521af831f0a37e304c5bb",
"assets/assets/fonts/Open_Sans/Open_Sans_Extra_Bold_Italic.ttf": "4991d99c8494b79917a682eac37d0555",
"assets/assets/fonts/Open_Sans/Open_Sans_Bold.ttf": "5bc6b8360236a197d59e55f72b02d4bf",
"assets/assets/fonts/Open_Sans/Open_Sans_Bold_Italic.ttf": "c1817c8c96e3dca8b13f779ee339b1bc",
"assets/assets/fonts/Open_Sans/Open_Sans_Light_Italic.ttf": "bc84c22b39c8edfaaa7e821477ce9215",
"assets/assets/fonts/Open_Sans/Open_Sans_Regular.ttf": "3eb5459d91a5743e0deaf2c7d7896b08",
"assets/assets/fonts/Open_Sans/Open_Sans_Semi_Bold.ttf": "af0b2118d34dcaf6e671ee67cf4d5be2",
"assets/assets/fonts/Open_Sans/Open_Sans_Light.ttf": "3dd221ea976bc4c617c40d366580bfe8",
"assets/assets/fonts/Open_Sans/Open_Sans_Medium.ttf": "0cbcac22e73cab1d6dbf2cfcc269b942",
"assets/assets/fonts/Open_Sans/Open_Sans_Semi_Bold_Italic.ttf": "ac6de8932b6838e3e7739115e2145a7e",
"assets/assets/fonts/Open_Sans/Open_Sans_Extra_Bold.ttf": "907d99fe588e4649680159671dfe74f4",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
