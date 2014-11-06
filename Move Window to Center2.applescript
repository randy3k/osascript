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

on match(windowWidth, windowHeight, w, h)
	set ret to ((windowWidth - (my drawWidth) * w) ^ 2 + (windowHeight - (my drawHeight) * h) ^ 2) ^ 0.5
	return ret ² 10
end match

tell application "System Events"
	tell process thefrontApp
		set windowResolution to size of the first window
		set windowWidth to item 1 of windowResolution
		set windowHeight to item 2 of windowResolution
		
		if my match(windowWidth, drawHeight, 1, 1) then
			set windowWidth to drawWidth * 0.4
			set windowHeight to drawHeight * 0.5
			set midX to drawWidth * 0.5 + (random number from -50 to 50)
			set midY to drawHeight * 0.5 + (random number from -50 to 50)
		else if my match(windowWidth, windowHeight, 0.4, 0.5) then
			set windowWidth to drawWidth * 0.55
			set windowHeight to drawHeight * 0.65
			set midX to drawWidth * 0.5 + (random number from -50 to 50)
			set midY to drawHeight * 0.5 + (random number from -50 to 50)
		else if my match(windowWidth, windowHeight, 0.55, 0.65) then
			set windowWidth to drawWidth * 0.7
			set windowHeight to drawHeight * 0.8
			set midX to drawWidth * 0.5 + (random number from -50 to 50)
			set midY to drawHeight * 0.5 + (random number from -50 to 50)
		else
			set windowWidth to drawWidth
			set windowHeight to drawHeight
			set midX to originX + drawWidth * 0.5
			set midY to originY + drawHeight * 0.5
		end if
		set the position of the first window to {midX - windowWidth / 2, midY - windowHeight / 2}
		set the size of the first window to {windowWidth, windowHeight}
	end tell
end tell
