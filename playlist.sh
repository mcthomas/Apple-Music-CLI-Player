#!/bin/sh
osascript -e 'on run args
	tell application "Music" to get name of every track of playlist (item 1 of args)
end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3  
