# Spot — Simple Prompts (run in order)

Flutter (Android) + Serverpod 4 + Google Maps.
After each phase: run the app, test it, commit.

Before Phase 1, run yourself:
```
serverpod quickstart spot     # pick Claude Code
cd spot                       # open this folder in Claude Code
```
Put your Google Maps key in a gitignored file (never paste it into a prompt or commit it).

---

## 1. Setup

```
Read AGENTS.md and the Serverpod skills. Then add a CLAUDE.md with these rules:
- Spot is an event discovery app for Delhi (Flutter Android + Serverpod 4).
- Follow the Serverpod docs/skills for syntax; use Serverpod's auth module.
- After model/endpoint changes: regenerate, migrate, confirm the server restarts.
- Join/capacity logic lives on the server.
- Never commit API keys.
- Location fallback: Connaught Place (28.6315, 77.2167) if GPS is off or the device is outside Delhi.
Don't write app code yet.
```

## 2. Login

```
Set up email sign up / sign in with Serverpod's auth module and a simple Flutter login screen. After login show a placeholder Home with a sign-out button. Make it run on an Android emulator against the local server and confirm it works.
```

## 3. Event model + basic endpoints

```
Create an Event model: title, description, category (debate, book_reading, games, festive, other), startsAt, lat, lng, locationName, capacity, hostId, status (open/cancelled), createdAt. Migrate.

Add endpoints (login required): createEvent, getNearbyEvents(lat, lng, radiusKm, category?) sorted by soonest and returning distance, and getEvent(id). Regenerate the client and test them.
```

## 4. Join / leave / my events

```
Create an Attendance model (event, userId, joinedAt, unique on event+userId). Add endpoints: joinEvent, leaveEvent (server-side capacity check, no double-join, no joining cancelled/past events), cancelEvent (host only), getMyEvents (hosting + joined), getAttendees (host only). Include attendeeCount, spotsLeft, and joinedByMe in event responses. Regenerate and test that capacity can't be exceeded.
```

## 5. Seed data

```
Add dev-only seed data: ~12 realistic upcoming events across Delhi (Hauz Khas, Connaught Place, Saket, Lajpat Nagar, DU North Campus, Khan Market) with a mix of categories, times in the next 2 weeks, and realistic titles and descriptions. Make it safe to run more than once.
```

## 6. App layout + Home feed

```
Build the app shell: a bottom nav with Home, Post, My Events, Profile, and a clean theme (one accent color, good spacing). On Home, get the user's location (geolocator) with the Delhi fallback and a "Browsing Delhi" banner, then show nearby events as cards: title, category chip, distance, time, spots left. Add pull-to-refresh, a loading state, an empty state, and category filter chips.
```

## 7. Event detail + join

```
Build the event detail screen: title, category, time, host, description, location, a small Google Map preview with a pin, spots left, and Join / Leave buttons wired to the server. Handle full and cancelled events and show errors in snackbars.
```
Map setup if needed: add google_maps_flutter, and read my Maps key from a gitignored file (e.g. local.properties) in the Android manifest.

## 8. Post an event

```
Build the Post screen: title, description, category, date and time pickers, capacity (min 2), and a location picker. The picker opens a full-screen Google Map where the user taps or drags to drop a pin, then types a place name. Validate inputs and, on success, open the new event's detail screen.
```

## 9. My events + host view

```
Build My Events with Hosting and Joined tabs. For hosted events add a manage screen showing the attendee list and a Cancel button with confirmation.
```

## 10. Map view on Home

```
Add a list/map toggle on Home. The map shows nearby events as pins; tapping a pin shows a small card that opens the event. Category filters should apply to both views.
```

## 11. Polish

```
Polish the UI: consistent spacing and typography, nicer event cards, friendly empty and error states, and a one-line welcome message ("Find what's happening around you, in person"). Fix any overflow issues on small screens.
```

## 12. Deploy + APK

Do first: create a project at console.serverpod.dev (enable the database).

```
Prepare to deploy to Serverpod Cloud and walk me through `serverpod cloud launch`. Make sure the seed data can be run once in production so the demo isn't empty. Then set the app's release server URL to the Cloud URL and help me build a release APK that works against it (including the Maps key setup for the release build).
```

## 13. README

```
Write a short README: what Spot is, features, tech stack (Flutter, Serverpod 4, Google Maps), how to run locally (including where to put the Maps key), and what's next. Check that no secrets are committed.
```

---

## Optional (only if you have time)

### A. Place search when posting

```
In the location picker, add a search box using Google Places autocomplete (Places API). Selecting a suggestion moves the map and fills the place name. Keep the tap-to-drop-pin option.
```

### B. Live attendee count

```
Using Serverpod streaming (follow the docs/skills), make the attendee count and spots left on the event detail screen update live when someone joins or leaves. Fall back to a normal refresh if the stream drops.
```
