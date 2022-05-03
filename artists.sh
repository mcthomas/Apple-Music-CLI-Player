#!/bin/sh
osascript -e 'tell application "Music" to get artist of every track' | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
