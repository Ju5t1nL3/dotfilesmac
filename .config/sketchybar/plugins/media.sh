#!/usr/bin/env bash

# Read Spotify's notification instead of querying the app: AppleScript queries
# can relaunch Spotify when a playback notification arrives during shutdown.
STATE=$(jq -r '.["Player State"] // empty' <<< "${INFO:-}" 2>/dev/null)
if [[ "$STATE" != "Playing" ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

TITLE=$(jq -r '.Name // empty' <<< "$INFO")
ARTIST=$(jq -r '.Artist // empty' <<< "$INFO")
MEDIA="$TITLE — $ARTIST"

sketchybar --set "$NAME" \
  label="$MEDIA" \
  drawing=on
