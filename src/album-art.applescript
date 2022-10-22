tell application "Music"
	try
		if player state is not stopped then
			set alb to (get album of current track)
			tell artwork 1 of current track
				if format is JPEG picture then
					set imgFormat to ".jpg"
				else
					set imgFormat to ".png"
				end if
			end tell
			set rawData to (get raw data of artwork 1 of current track)
		else
			return
		end if
	on error
		display dialog "Problem getting track info." buttons {"OK"}
		return
	end try
end tell
--get current path
tell application "Finder"
	set current_path to container of (path to me) as alias
end tell
--create path to save image as jpg or png
set newPath to ((current_path as text) & "tmp" & imgFormat) as text
try
	--create file
	tell me to set fileRef to (open for access newPath with write permission)
	--overwrite existing file
	write rawData to fileRef starting at 0
	tell me to close access fileRef
on error m number n
	log n
	log m
	try
		tell me to close access fileRef
	end try
end try
