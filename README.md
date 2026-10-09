# Spot

**Find what's happening around you, in person.**

Spot is an Android app for discovering and hosting small in-person events in Delhi — debates, book readings, game nights and festive meet-ups. Open the app, see what's on near you, join with one tap, or post your own.

## Features

- **Email sign-up / sign-in** with verification codes (Serverpod auth).
- **Nearby feed** of upcoming events, soonest first, with distance, time, place, host and spots left. Filter by category; pull to refresh.
- **List or map**: switch Home to a Google Map of pins; tap a pin for a preview card.
- **Delhi fallback**: if location is off, denied, or you're outside Delhi, Spot browses from Connaught Place and says so.
- **Event detail** with a map preview, and Join / Leave.
- **Fair joining**: capacity, double joins, and joining cancelled or past events are all checked on the server, inside a transaction that locks the event row — two people can't grab the last spot.
- **Post an event**: title, description, category, date and time, capacity, and a place picked on a full-screen map.
- **My Events**: Hosting and Joined tabs. Hosts can see the attendee list and cancel an event.
- Light and dark mode; tested on small screens with large text.

## Tech stack

- **Flutter** (Android) — `spot/spot_flutter`
- **Serverpod 4** (Dart server, PostgreSQL, built-in auth) — `spot/spot_server`, with the generated client in `spot/spot_client`
- **Google Maps** (`google_maps_flutter`) and **geolocator**
- **Serverpod Cloud** for hosting

## Run it locally

You need the Flutter SDK, the Serverpod CLI (`dart pub global activate serverpod_cli`), and an Android emulator or device. Docker is not required — development uses an embedded PostgreSQL.

1. **Add your Google Maps key.** Create or edit `spot/spot_flutter/android/local.properties` (it's gitignored) and add:

   ```properties
   MAPS_API_KEY=your-key-here
   ```

   The key needs the *Maps SDK for Android* enabled. It's injected into the Android manifest at build time, so it never appears in source.

2. **Start an emulator**, e.g. `emulator -avd <name>`.

3. **Start the server and app:**

   ```bash
   cd spot/spot_server
   serverpod start
   ```

   This applies database migrations, seeds ~12 demo events across Delhi, and launches the app on `emulator-5554`, pointed at `http://10.0.2.2:8080/` (the emulator's address for your computer). Code changes hot-reload.

   Verification codes for sign-up are printed in the server log, since emails aren't sent in development.

4. **Run the tests:**

   ```bash
   cd spot/spot_server && dart test
   ```

   Includes a test that fires 10 simultaneous joins at a 3-person event and checks exactly 3 succeed.

> On a physical phone, run the app with `--dart-define=SERVER_URL=http://<your-computer-ip>:8080/`.

## Deploy

The server deploys to Serverpod Cloud with `serverpod cloud launch` from `spot/spot_server`. To fill a fresh production database with the demo events, set the `SPOT_SEED=true` variable for one deploy (`serverpod cloud variable set SPOT_SEED true`), then unset it. Seeding is idempotent, so running it twice does no harm.

Build a release APK against the deployed server:

```bash
spot/scripts/build_release_apk.sh https://<your-project>.api.serverpod.space/
```

Release signing reads `spot/spot_flutter/android/key.properties` and its keystore (both gitignored). If you restrict your Maps key to Android apps, add package `com.mulaqaat.spot` with the SHA-1 of your release key (`cd spot/spot_flutter/android && ./gradlew signingReport`).

## What's next

- **Place search** when posting (Google Places autocomplete).
- **Live attendee counts** on the event screen via Serverpod streams.
- Push notifications for reminders and cancellations.
- Event photos, and a short host profile.
- Sharing an event link, and calendar export.
