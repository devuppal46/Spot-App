#!/usr/bin/env bash
# Builds a release APK that talks to the deployed server.
#
# Usage: scripts/build_release_apk.sh https://<project>.api.serverpod.space/
#
# Needs MAPS_API_KEY in spot_flutter/android/local.properties, and (for your
# own signing key) spot_flutter/android/key.properties. Both are gitignored.
set -euo pipefail

url="${1:-${SPOT_SERVER_URL:-}}"
if [[ -z "$url" ]]; then
  echo "usage: $0 <server-url>   e.g. https://spot.api.serverpod.space/" >&2
  exit 1
fi
[[ "$url" == */ ]] || url="$url/"
if [[ "$url" != https://* ]]; then
  echo "error: release builds only allow https URLs (got $url)" >&2
  exit 1
fi

cd "$(dirname "$0")/../spot_flutter"

if ! grep -q '^MAPS_API_KEY=.' android/local.properties 2>/dev/null; then
  echo "error: add MAPS_API_KEY=... to spot_flutter/android/local.properties" >&2
  exit 1
fi
[[ -f android/key.properties ]] ||
  echo "warning: no android/key.properties — signing with the debug key" >&2

flutter build apk --release --dart-define=SERVER_URL="$url"
echo
echo "APK: $(pwd)/build/app/outputs/flutter-apk/app-release.apk (server: $url)"
