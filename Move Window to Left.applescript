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

on match(windowWidth, w)
	set ret to ((windowWidth - (my screenWidth) * w) ^ 2) ^ 0.5
	return ret is less than or equal to 10
end match

tell application "System Events"
	tell process thefrontApp
		set windowResolution to size of the first window
		set windowPos to position of the first window
		set windowWidth to item 1 of windowResolution
		set windowX to item 1 of windowPos
		if my match(windowWidth, 0.6) and windowX is equal to originX then
			set the size of the first window to {screenWidth * 0.5, screenHeight}
			set the position of the first window to {originX, originY}
		else if my match(windowWidth, 0.5) and windowX is equal to originX then
			set the size of the first window to {screenWidth * 0.4, screenHeight}
			set the position of the first window to {originX, originY}
		else
			set the size of the first window to {screenWidth * 0.6, screenHeight}
			set the position of the first window to {originX, originY}
			-- since the size may not be corrent for some position, do sizing again
			set the size of the first window to {screenWidth * 0.6, screenHeight}
		end if
	end tell
end tell