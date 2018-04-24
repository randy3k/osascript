use framework "AppKit"
use scripting additions

on getMainScreen()
	set nss to current application's NSScreen
	repeat with sc in nss's screens()
		set f to sc's frame()
		if item 1 of item 1 of f is 0 and item 2 of item 1 of f is 0 then
			return f
		end if
	end repeat
	return 0
end getMainScreen

set actualScreen to current application's NSScreen's mainScreen's frame()
set actualWidth to item 1 of item 2 of actualScreen
set actualHeight to item 2 of item 2 of actualScreen
set visibleScreen to current application's NSScreen's mainScreen's visibleFrame()
set screenWidth to item 1 of item 2 of visibleScreen
set screenHeight to item 2 of item 2 of visibleScreen
set originX to item 1 of item 1 of visibleScreen
set originY to ((item 2 of item 2 of my getMainScreen()) - (item 2 of item 1 of visibleScreen) - screenHeight)


tell application "System Events" to tell (process 1 where frontmost is true)
	set windowResolution to size of the first window
	set windowWidth to item 1 of windowResolution
	set windowHeight to item 2 of windowResolution

	set windowWidth to screenWidth * 0.55
	set windowHeight to screenHeight * 0.65
	set midX to originX + screenWidth * 0.5 + (random number from -50 to 50)
	set midY to originY + screenHeight * 0.5 + (random number from -50 to 50)

	set the position of the first window to {midX - windowWidth / 2, midY - windowHeight / 2}
	set the size of the first window to {windowWidth, windowHeight}
end tell
