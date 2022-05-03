#!/bin/sh
init=1
while :
do
vol=$(osascript -e 'get volume settings')
shuffle=$(osascript -e 'tell application "Music" to get shuffle enabled')
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
	rm ~/Library/Scripts/tmp*
	osascript ~/Library/Scripts/album-art.applescript
	if [ -f ~/Library/Scripts/tmp.png ]; then
		art=$(clear; viu ~/Library/Scripts/tmp.png -w 39 -h 13)
	else 
		art=$(clear; viu ~/Library/Scripts/tmp.jpg -w 39 -h 13)
	fi
	cyan=$(echo -e '\e[00;36m')
	green=$(echo -e '\e[00;32m')
	nocolor=$(echo -e '\033[0m')
fi
vol=$(echo $(awk -F ':|,' '{print $2}' <<< $vol))
if [ $vol = 0 ]; then
	volIcon=🔇
else
	volIcon=🔊
fi
vol=$(( vol / 12 ))
if [ $shuffle = 'false' ]; then
	shuffleIcon=🔁
else
	shuffleIcon=🔀
fi
volBars='▁▂▃▄▅▆▇█'
volBG=${volBars:$vol}
vol=${volBars:0:$vol}
progressBars='▇▇▇▇▇▇▇▇▇'
percentRemain=$(( (curr * 100) / end / 10 ))
progBG=${progressBars:$percentRemain} 
prog=${progressBars:0:$percentRemain} 
paste <(printf %s "$art") <(printf %s "") <(printf %s "") <(printf %s "") <(printf %s "") <(printf '%s\n' "$name" "$artist - $record" "$shuffleIcon $(echo $currMin:$currSec ${cyan}${prog}${nocolor}${progBG} $endMin:$endSec)" "$volIcon $(echo "${green}$vol${nocolor}$volBG")")
sleep 1
done