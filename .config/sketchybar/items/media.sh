#!/bin/bash

sketchybar --add event spotify_change "com.spotify.client.PlaybackStateChanged"

sketchybar --add item media e \
            --set media label.max_chars=30 \
                        icon.padding_left=0 \
                        scroll_texts=on \
                        icon=􀑪             \
                        background.drawing=off \
                        script="$PLUGIN_DIR/media.sh" \
            --subscribe media spotify_change