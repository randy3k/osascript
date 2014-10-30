on frontApp()
	tell application "System Events"
		name of first process whose frontmost is true
	end tell
end frontApp

set thefrontApp to frontApp()

tell application "Finder"
	set screenResolution to bounds of window of desktop
end tell

set screenWidth to item 3 of screenResolution
set screenHeight to item 4 of screenResolution
set drawWidth to screenWidth
set drawHeight to screenHeight
set originX to 0
set originY to 0

tell application "System Events"
	tell process "Dock"
		set dock_dimensions to size in list 1
		log dock_dimensions
		set dock_width to item 1 of dock_dimensions
		set dock_height to item 2 of dock_dimensions
	end tell
	tell dock preferences
		if autohide is false then
			if screen edge is bottom then
				set drawHeight to drawHeight - dock_height
			else if screen edge is left then
				set drawWidth to drawWidth - dock_width
				set originX to dock_width
			else if screen edge is right then
				set drawWidth to drawWidth - dock_width
			end if
		end if
	end tell
end tell
log {drawWidth, drawHeight, originX, originY}

on match(windowWidth, w)
	set ret to ((windowWidth - (my drawWidth) * w) ^ 2) ^ 0.5
	return ret is less than or equal to 10
end match

tell application "System Events"
	tell process thefrontApp
		set windowResolution to size of the first window
		set windowPos to position of the first window
		set windowWidth to item 1 of windowResolution
		set windowX to item 1 of windowPos
		if my match(windowWidth, 0.6) and windowX is equal to originX then
			set the size of the first window to {drawWidth * 0.5, drawHeight}
			set the position of the first window to {originX, originY}
		else if my match(windowWidth, 0.5) and windowX is equal to originX then
			set the size of the first window to {drawWidth * 0.4, drawHeight}
			set the position of the first window to {originX, originY}
		else
			set the size of the first window to {drawWidth * 0.6, drawHeight}
			set the position of the first window to {originX, originY}
			-- since the size may not be corrent for some position, do sizing again
			set the size of the first window to {drawWidth * 0.6, drawHeight}
		end if
	end tell
end tell