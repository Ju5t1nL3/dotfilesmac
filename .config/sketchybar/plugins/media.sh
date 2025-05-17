#!/usr/bin/env bash

# 1) Is Spotify running?
if ! pgrep -x Spotify >/dev/null; then
  sketchybar --set $NAME drawing=off
  exit
fi

# 2) Get player state
STATE=$(osascript -e 'tell application "Spotify" to player state')
if [[ "$STATE" != "playing" ]]; then
  sketchybar --set $NAME drawing=off
  exit
fi

# 3) Get track info
TITLE=$(osascript -e 'tell application "Spotify" to name of current track')
ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track')
MEDIA="$TITLE — $ARTIST"

# 4) Update the bar
sketchybar --set $NAME \
  label="$MEDIA" \
  drawing=on
