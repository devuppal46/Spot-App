# Spot

@AGENTS.md

## Project rules

- Spot is an event discovery app for Delhi (Flutter Android + Serverpod 4).
- Follow the Serverpod docs/skills (`.claude/skills/serverpod-*`) for syntax; use Serverpod's auth module (`serverpod_auth_idp`) for sign-in.
- After model/endpoint changes: regenerate, create + apply the migration, and confirm the server restarts cleanly.
- Join/capacity logic lives on the server. The app never decides whether a join is allowed.
- Never commit API keys. The Google Maps key lives in `spot_flutter/android/local.properties` (gitignored) as `MAPS_API_KEY=...`.
- Location fallback: Connaught Place (28.6315, 77.2167) if GPS is off, permission is denied, or the device is outside Delhi.
