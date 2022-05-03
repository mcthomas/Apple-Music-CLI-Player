#!/bin/sh
osascript -e 'tell application "Music" to get album of every track' | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
