#!/bin/sh
osascript -e 'tell application "Music" to get name of playlists' | tr "," "\n" | pr -T -a -3
