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


on approx(a, b)
	set ret to ((a - b) ^ 2) ^ 0.5
	return ret is less than or equal to 10
end approx

tell application "System Events" to tell (process 1 where frontmost is true)
	set windowResolution to size of the first window
	set windowPos to position of the first window
	set windowWidth to item 1 of windowResolution
	set windowHeight to item 2 of windowResolution
	set windowX to item 1 of windowPos
	set windowY to item 2 of windowPos

	if my approx(windowX + windowWidth, originX + screenWidth) then
		tell application "Finder" to set thefolder to (container of (path to me)) as text
		run script (thefolder & "Move Window to Center.applescript") as alias

	else if my approx(windowWidth, 0.6 * screenWidth) and windowX is equal to originX then
		set the size of the first window to {screenWidth * 0.5, windowHeight}
		set the position of the first window to {originX, windowY}

	else if my approx(windowWidth, 0.5 * screenWidth) and windowX is equal to originX then
		set the size of the first window to {screenWidth * 0.4, windowHeight}
		set the position of the first window to {originX, windowY}

	else if my approx(windowWidth, 0.4 * screenWidth) and windowX is equal to originX then
		set the position of the first window to {originX, windowY}
		set the size of the first window to {screenWidth * 0.6, windowHeight}

	else
		set the size of the first window to {screenWidth * 0.6, screenHeight}
		set the position of the first window to {originX, originY}
		-- since the size may not be corrent for some position, do sizing again
		set the size of the first window to {screenWidth * 0.6, screenHeight}

	end if
end tell
