#!/bin/sh
osascript -e 'tell application "Music" to get name of every track' | tr "," "\n" | sort | pr -T -a -3
