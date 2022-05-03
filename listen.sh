#!/bin/sh
input=$2
if [ $1 = "-s" ] 
then
	shift
	osascript -e 'on run argv
  	tell application "Music" to play track (item 1 of argv)
	end' "$*"
	np
elif [ $1 = "-r" ] 
then
  	shift
  	osascript -e 'on run argv' -e 'tell application "Music"' -e 'if (exists playlist "temp_playlist") then' -e 'delete playlist "temp_playlist"' -e 'end if' -e 'set name of (make new playlist) to "temp_playlist"' -e 'set theseTracks to every track of playlist "Library" whose album is (item 1 of argv)' -e 'repeat with thisTrack in theseTracks' -e 'duplicate thisTrack to playlist "temp_playlist"' -e 'end repeat' -e 'play playlist "temp_playlist"' -e 'end tell' -e 'end' "$*"
  	np
elif [ $1 = "-a" ] 
then
  	shift
  	osascript -e 'on run argv' -e 'tell application "Music"' -e 'if (exists playlist "temp_playlist") then' -e 'delete playlist "temp_playlist"' -e 'end if' -e 'set name of (make new playlist) to "temp_playlist"' -e 'set theseTracks to every track of playlist "Library" whose artist is (item 1 of argv)' -e 'repeat with thisTrack in theseTracks' -e 'duplicate thisTrack to playlist "temp_playlist"' -e 'end repeat' -e 'play playlist "temp_playlist"' -e 'end tell' -e 'end' "$*"
  	np
elif [ $1 = "-p" ]
then
	shift
 	osascript -e 'on run argv
    	tell application "Music" to play playlist (item 1 of argv)
  	end' "$*"
  	np
fi
