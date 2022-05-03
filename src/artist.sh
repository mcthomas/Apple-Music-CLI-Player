#!/bin/sh
osascript -e 'on run args
	tell application "Music" to get name of every track whose artist is (item 1 of args)
end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
