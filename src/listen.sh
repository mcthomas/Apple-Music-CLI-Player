#!/bin/sh
input=$2
if [ $1 = "-p" ]
then
	if [ "$#" -eq 1 ]; then
		playlist=$(osascript -e 'tell application "Music" to get name of playlists' | tr "," "\n" | fzf)
		set -- ${playlist:1}
	else
		shift
	fi
	osascript -e 'on run argv
		tell application "Music" to play playlist (item 1 of argv)
	end' "$*"
elif [ $1 = "-s" ] 
then
	if [ "$#" -eq 1 ]; then
		song=$(osascript -e 'tell application "Music" to get name of every track' | tr "," "\n" | fzf)
		set -- ${song:1}
	else
		shift
	fi
osascript -e 'on run argv
	tell application "Music" to play track (item 1 of argv)
end' "$*"
elif [ $1 = "-r" ] 
then
	if [ "$#" -eq 1 ]; then
		record=$(osascript -e 'tell application "Music" to get album of every track' | tr "," "\n" | sort | awk '!seen[$0]++' | fzf)
		set -- ${record:1}
	else
		shift
	fi
	osascript -e 'on run argv' -e 'tell application "Music"' -e 'if (exists playlist "temp_playlist") then' -e 'delete playlist "temp_playlist"' -e 'end if' -e 'set name of (make new playlist) to "temp_playlist"' -e 'set theseTracks to every track of playlist "Library" whose album is (item 1 of argv)' -e 'repeat with thisTrack in theseTracks' -e 'duplicate thisTrack to playlist "temp_playlist"' -e 'end repeat' -e 'play playlist "temp_playlist"' -e 'end tell' -e 'end' "$*"
elif [ $1 = "-a" ] 
then
	if [ "$#" -eq 1 ]; then
		artist=$(osascript -e 'tell application "Music" to get artist of every track' | tr "," "\n" | sort | awk '!seen[$0]++' | fzf)
		set -- ${artist:1}
	else
		shift
	fi
	osascript -e 'on run argv' -e 'tell application "Music"' -e 'if (exists playlist "temp_playlist") then' -e 'delete playlist "temp_playlist"' -e 'end if' -e 'set name of (make new playlist) to "temp_playlist"' -e 'set theseTracks to every track of playlist "Library" whose artist is (item 1 of argv)' -e 'repeat with thisTrack in theseTracks' -e 'duplicate thisTrack to playlist "temp_playlist"' -e 'end repeat' -e 'play playlist "temp_playlist"' -e 'end tell' -e 'end' "$*"
elif [ $1 = "-g" ] 
then
	if [ "$#" -eq 1 ]; then
		genre=$(osascript -e 'tell application "Music" to get genre of every track' | tr "," "\n" | sort | awk '!seen[$0]++' | fzf)
		set -- ${genre:1}
	else
		shift
	fi
	osascript -e 'on run argv' -e 'tell application "Music"' -e 'if (exists playlist "temp_playlist") then' -e 'delete playlist "temp_playlist"' -e 'end if' -e 'set name of (make new playlist) to "temp_playlist"' -e 'set theseTracks to every track of playlist "Library" whose genre is (item 1 of argv)' -e 'repeat with thisTrack in theseTracks' -e 'duplicate thisTrack to playlist "temp_playlist"' -e 'end repeat' -e 'play playlist "temp_playlist"' -e 'end tell' -e 'end' "$*"
fi
