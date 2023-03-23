#!/bin/zsh
np(){
	init=1
	help='false'
	while :
	do
		vol=$(osascript -e 'tell application "Music" to get sound volume')
		shuffle=$(osascript -e 'tell application "Music" to get shuffle enabled')
		repeat=$(osascript -e 'tell application "Music" to get song repeat')
	    keybindings="
Keybindings:

p                       Play / Pause
f                       Forward one track
b                       Backward one track
>                       Begin fast forwarding current track
<                       Begin rewinding current track
R                       Resume normal playback
+                       Increase Music.app volume 5%
-                       Decrease Music.app volume 5%
s                       Toggle shuffle
r                       Toggle song repeat
q                       Quit np
Q                       Quit np and Music.app
?                       Show / hide keybindings"
		duration=$(osascript -e 'tell application "Music" to get {player position} & {duration} of current track')
		arr=(`echo ${duration}`)
		curr=$(cut -d . -f 1 <<< ${arr[-2]})
		currMin=$(echo $(( curr / 60 )))
		currSec=$(echo $(( curr % 60 )))
		if [ ${#currMin} = 1 ]; then
			currMin="0$currMin"
		fi
		if [ ${#currSec} = 1 ]; then
			currSec="0$currSec"
		fi
		if (( curr < 2 || init == 1 )); then
			init=0
			name=$(osascript -e 'tell application "Music" to get name of current track')
			name=${name:0:50}
			artist=$(osascript -e 'tell application "Music" to get artist of current track')
			artist=${artist:0:50}
			record=$(osascript -e 'tell application "Music" to get album of current track')
			record=${record:0:50}
			end=$(cut -d . -f 1 <<< ${arr[-1]})
			endMin=$(echo $(( end / 60 )))
			endSec=$(echo $(( end % 60 )))
			if [ ${#endMin} = 1 ]
			then
				endMin="0$endMin"
			fi
			if [ ${#endSec} = 1 ]
			then
				endSec="0$endSec"
			fi
			if [ "$1" != "-t" ]
			then
				rm ~/Library/Scripts/tmp*
				osascript ~/Library/Scripts/album-art.applescript
				if [ -f ~/Library/Scripts/tmp.png ]; then
					art=$(clear; viu -b ~/Library/Scripts/tmp.png -w 31 -h 14)
				else
					art=$(clear; viu -b ~/Library/Scripts/tmp.jpg -w 31 -h 14)
				fi
			fi
			cyan=$(echo -e '\e[00;36m')
			magenta=$(echo -e '\033[01;35m')
			nocolor=$(echo -e '\033[0m')
		fi
		if [ $vol = 0 ]; then
			volIcon=🔇
		else
			volIcon=🔊
		fi
		vol=$(( vol / 12 ))
		if [ $shuffle = 'false' ]; then
			shuffleIcon='➡️ '
		else
			shuffleIcon=🔀
		fi
		if [ $repeat = 'off' ]; then
			repeatIcon='↪️ '
		elif [ $repeat = 'one' ]; then
			repeatIcon=🔂
		else
			repeatIcon=🔁
		fi
		volBars='▁▂▃▄▅▆▇'
		volBG=${volBars:$vol}
		vol=${volBars:0:$vol}
		progressBars='▇▇▇▇▇▇▇▇▇'
		percentRemain=$(( (curr * 100) / end / 10 ))
		progBG=${progressBars:$percentRemain}
		prog=${progressBars:0:$percentRemain}
		if [ "$1" = "-t" ]
		then
			clear
			paste <(printf '%s\n' "$name" "$artist - $record" "$shuffleIcon $repeatIcon $(echo $currMin:$currSec ${cyan}${prog}${nocolor}${progBG} $endMin:$endSec)" "$volIcon $(echo "${magenta}$vol${nocolor}$volBG")") 
		else
			paste <(printf %s "$art") <(printf %s "") <(printf %s "") <(printf %s "") <(printf '%s\n' "$name" "$artist - $record" "$shuffleIcon $repeatIcon $(echo $currMin:$currSec ${cyan}${prog}${nocolor}${progBG} $endMin:$endSec)" "$volIcon $(echo "${magenta}$vol${nocolor}$volBG")") 
		fi
		if [ $help = 'true' ]; then
			printf '%s\n' "$keybindings"
		fi
		input=$(/bin/bash -c "read -n 1 -t 1 input; echo \$input | xargs")
		if [[ "${input}" == *"s"* ]]; then
			if $shuffle ; then
				osascript -e 'tell application "Music" to set shuffle enabled to false'
			else
				osascript -e 'tell application "Music" to set shuffle enabled to true'
			fi
		elif [[ "${input}" == *"r"* ]]; then
			if [ $repeat = 'off' ]; then
				osascript -e 'tell application "Music" to set song repeat to all'
			elif [ $repeat = 'all' ]; then
				osascript -e 'tell application "Music" to set song repeat to one'
			else
				osascript -e 'tell application "Music" to set song repeat to off'
			fi
		elif [[ "${input}" == *"+"* ]]; then
			osascript -e 'tell application "Music" to set sound volume to sound volume + 5'
		elif [[ "${input}" == *"-"* ]]; then
			osascript -e 'tell application "Music" to set sound volume to sound volume - 5'
		elif [[ "${input}" == *">"* ]]; then
			osascript -e 'tell application "Music" to fast forward'
		elif [[ "${input}" == *"<"* ]]; then
			osascript -e 'tell application "Music" to rewind'
		elif [[ "${input}" == *"R"* ]]; then
			osascript -e 'tell application "Music" to resume'
		elif [[ "${input}" == *"f"* ]]; then
			osascript -e 'tell app "Music" to play next track'
		elif [[ "${input}" == *"b"* ]]; then
			osascript -e 'tell app "Music" to back track'
		elif [[ "${input}" == *"p"* ]]; then
			osascript -e 'tell app "Music" to playpause'
		elif [[ "${input}" == *"q"* ]]; then
			clear
			exit
		elif [[ "${input}" == *"Q" ]]; then
			killall Music
			clear
			exit
		elif [[ "${input}" == *"?"* ]]; then
			if [ $help = 'false' ]; then
				help='true'
			else
				help='false'
			fi
		fi
		read -sk 1 -t 0.001
	done
}
list(){
	usage="Usage: list [-grouping] [name]

  -s                    List all songs.
  -r                    List all records.
  -r PATTERN            List all songs in the record PATTERN.
  -a                    List all artists.
  -a PATTERN            List all songs by the artist PATTERN.
  -p                    List all playlists.
  -p PATTERN            List all songs in the playlist PATTERN.
  -g                    List all genres.
  -g PATTERN            List all songs in the genre PATTERN."
	if [ "$#" -eq 0 ]; then
		printf '%s\n' "$usage";
	else
		if [ $1 = "-p" ]
		then
			if [ "$#" -eq 1 ]; then
				shift
				osascript -e 'tell application "Music" to get name of playlists' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | /usr/bin/pr -t -a -3
			else
				shift
				osascript -e 'on run args' -e 'tell application "Music" to get name of every track of playlist (item 1 of args)' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | /usr/bin/pr -t -a -3
			fi
		elif [ $1 = "-s" ]
		then
			if [ "$#" -eq 1 ]; then
				shift
				osascript -e 'on run args' -e 'tell application "Music" to get name of every track' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | /usr/bin/pr -t -a -3
			else
				echo $usage
			fi
		elif [ $1 = "-r" ]
		then
			if [ "$#" -eq 1 ]; then
				shift
				osascript -e 'on run args' -e 'tell application "Music" to get album of every track' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | /usr/bin/pr -t -a -3
			else
				shift
				osascript -e 'on run args' -e 'tell application "Music" to get name of every track whose album is (item 1 of args)' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | /usr/bin/pr -t -a -3
			fi
		elif [ $1 = "-a" ]
		then
			if [ "$#" -eq 1 ]; then
				shift
				osascript -e 'on run args' -e 'tell application "Music" to get artist of every track' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | /usr/bin/pr -t -a -3
			else
				shift
				osascript -e 'on run args' -e 'tell application "Music" to get name of every track whose artist is (item 1 of args)' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | /usr/bin/pr -t -a -3
			fi
		elif [ $1 = "-g" ]
		then
			if [ "$#" -eq 1 ]; then
				shift
				osascript -e 'on run args' -e 'tell application "Music" to get genre of every track' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | /usr/bin/pr -t -a -3
			else
				shift
				osascript -e 'on run args' -e 'tell application "Music" to get name of every track whose genre is (item 1 of args)' -e 'end' "$*" | tr "," "\n" | sort | awk '!seen[$0]++' | /usr/bin/pr -t -a -3
			fi
		else
			printf '%s\n' "$usage";
		fi
	fi
}

play() {
	usage="Usage: play [-grouping] [name]

  -s                    Fzf for a song and begin playback.
  -s PATTERN            Play the song PATTERN.
  -r                    Fzf for a record and begin playback.
  -r PATTERN            Play from the record PATTERN.
  -a                    Fzf for an artist and begin playback.
  -a PATTERN            Play from the artist PATTERN.
  -p                    Fzf for a playlist and begin playback.
  -p PATTERN            Play from the playlist PATTERN.
  -g                    Fzf for a genre and begin playback.
  -g PATTERN            Play from the genre PATTERN.
  -l                    Play from your entire library."
	if [ "$#" -eq 0 ]; then
		printf '%s\n' "$usage"
	else
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
		elif [ $1 = "-l" ]
		then
			osascript -e 'tell application "Music"' -e 'play playlist "Library"' -e 'end tell'
		else
			printf '%s\n' "$usage";
		fi
	fi
}

usage="Usage: am.sh [function] [-grouping] [name]

  list -s              	List all songs in your library.
  list -r              	List all records.
  list -r PATTERN       List all songs in the record PATTERN.
  list -a              	List all artists.
  list -a PATTERN       List all songs by the artist PATTERN.
  list -p              	List all playlists.
  list -p PATTERN       List all songs in the playlist PATTERN.
  list -g              	List all genres.
  list -g PATTERN       List all songs in the genre PATTERN.

  play -s               Fzf for a song and begin playback.
  play -s PATTERN       Play the song PATTERN.
  play -r              	Fzf for a record and begin playback.
  play -r PATTERN       Play from the record PATTERN.
  play -a              	Fzf for an artist and begin playback.
  play -a PATTERN       Play from the artist PATTERN.
  play -p              	Fzf for a playlist and begin playback.
  play -p PATTERN       Play from the playlist PATTERN.
  play -g              	Fzf for a genre and begin playback.
  play -g PATTERN       Play from the genre PATTERN.
  play -l              	Play from your entire library.
  
  np                    Open the \"Now Playing\" TUI widget.
                        (Music.app track must be actively
			playing or paused)
  np -t			Open in text mode (disables album art)
 
  np keybindings:

  p                     Play / Pause
  f                     Forward one track
  b                     Backward one track
  >                     Begin fast forwarding current track
  <                     Begin rewinding current track
  R                     Resume normal playback
  +                     Increase Music.app volume 5%
  -                     Decrease Music.app volume 5%
  s                     Toggle shuffle
  r                     Toggle song repeat
  q                     Quit np
  Q                     Quit np and Music.app
  ?                     Show / hide keybindings"
if [ "$#" -eq 0 ]; then
	printf '%s\n' "$usage";
else
	if [ $1 = "np" ]
	then
		shift
		np "$@"
	elif [ $1 = "list" ]
	then
		shift
		list "$@"
	elif [ $1 = "play" ]
	then
		shift
		play "$@"
	else
		printf '%s\n' "$usage";
	fi
fi
