on frontApp()
	tell application "System Events"
		name of first process whose frontmost is true
	end tell
end frontApp

set thefrontApp to frontApp()

use framework "CoreGraphics"
use scripting additions
set sizes to item 1 of (current application's NSScreen's mainScreen's visibleFrame as list)
set screenWidth to width of |size| of sizes
set screenHeight to height of |size| of sizes
set originX to x of origin of sizes
set originY to y of origin of sizes

on match(windowWidth, windowHeight, w, h)
	set ret to ((windowWidth - (my screenWidth) * w) ^ 2 + (windowHeight - (my screenHeight) * h) ^ 2) ^ 0.5
	return ret ² 20
end match

tell application "System Events"
	tell process thefrontApp
		set windowResolution to size of the first window
		set windowWidth to item 1 of windowResolution
		set windowHeight to item 2 of windowResolution
		
		if my match(windowWidth, windowHeight, 0.7, 0.8) then
			set windowWidth to screenWidth * 0.55
			set windowHeight to screenHeight * 0.65
			set midX to originX + screenWidth * 0.5 + (random number from -50 to 50)
			set midY to originY + screenHeight * 0.5 + (random number from -50 to 50)
		else if my match(windowWidth, windowHeight, 0.55, 0.65) then
			set windowWidth to screenWidth * 0.4
			set windowHeight to screenHeight * 0.5
			set midX to originX + screenWidth * 0.5 + (random number from -50 to 50)
			set midY to originY + screenHeight * 0.5 + (random number from -50 to 50)
		else if my match(windowWidth, windowHeight, 0.4, 0.5) then
			set windowWidth to screenWidth
			set windowHeight to screenHeight
			set midX to originX + screenWidth * 0.5
			set midY to originY + screenHeight * 0.5
		else
			set windowWidth to screenWidth * 0.7
			set windowHeight to screenHeight * 0.8
			set midX to originX + screenWidth * 0.5 + (random number from -50 to 50)
			set midY to originY + screenHeight * 0.5 + (random number from -50 to 50)
		end if
		set the position of the first window to {midX - windowWidth / 2, midY - windowHeight / 2}
		set the size of the first window to {windowWidth, windowHeight}
	end tell
end tell
