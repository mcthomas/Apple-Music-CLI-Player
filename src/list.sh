#!/bin/sh
usage="Usage: list.sh [-grouping] [-name]
  -s              List all songs.
  -r              List all records.
  -r PATTERN      List all songs in the record PATTERN.
  -a              List all artists.
  -a PATTERN      List all songs by the artist PATTERN.
  -p              List all playlists.
  -p PATTERN      List all songs in the playlist PATTERN.
  -g              List all genres.
  -g PATTERN      List all songs in the genre PATTERN."
if [ "$#" -eq 0 ]; then
	echo -e $usage
else
if [ $1 = "-p" ]
then
	if [ "$#" -eq 1 ]; then
		shift
		osascript -e 'tell application "Music" to get name of playlists' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
	else
		shift
		osascript -e 'on run args' -e 'tell application "Music" to get name of every track of playlist (item 1 of args)' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
	fi
elif [ $1 = "-s" ] 
then
	if [ "$#" -eq 1 ]; then
		shift
		osascript -e 'on run args' -e 'tell application "Music" to get name of every track' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3  
	else
		echo $usage
	fi
elif [ $1 = "-r" ] 
then
	if [ "$#" -eq 1 ]; then
		shift
		osascript -e 'on run args' -e 'tell application "Music" to get album of every track' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3  
	else
		shift
		osascript -e 'on run args' -e 'tell application "Music" to get name of every track whose album is (item 1 of args)' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
	fi
elif [ $1 = "-a" ] 
then
	if [ "$#" -eq 1 ]; then
		shift
		osascript -e 'on run args' -e 'tell application "Music" to get artist of every track' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
	else
		shift
		osascript -e 'on run args' -e 'tell application "Music" to get name of every track whose artist is (item 1 of args)' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
	fi
elif [ $1 = "-g" ] 
then
	if [ "$#" -eq 1 ]; then
		shift
		osascript -e 'on run args' -e 'tell application "Music" to get genre of every track' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
	else
		shift
		osascript -e 'on run args' -e 'tell application "Music" to get name of every track whose genre is (item 1 of args)' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | pr -T -a -3
	fi
else
	echo $usage
fi
fi
