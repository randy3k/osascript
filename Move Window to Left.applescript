use framework "CoreGraphics"
use scripting additions
set sizes0 to item 1 of (current application's NSScreen's mainScreen's frame as list)
set actualWidth to width of |size| of sizes0
set sizes to item 1 of (current application's NSScreen's mainScreen's visibleFrame as list)
set screenWidth to width of |size| of sizes
set screenHeight to height of |size| of sizes
set originX to x of origin of sizes
set originY to y of origin of sizes
log {sizes0}
log {sizes}

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
	log windowPos
	
	if my approx(windowX + windowWidth, originX + screenWidth) then
		tell application "Finder" to set thefolder to (container of (path to me)) as text
		run script (thefolder & "Move Window to Center.applescript") as alias
		return
	end if
	
	if my approx(windowWidth, 0.6 * screenWidth) and windowX is equal to originX then
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
		set the position of the first window to {originX, 0}
		-- since the size may not be corrent for some position, do sizing again
		set the size of the first window to {screenWidth * 0.6, screenHeight}
		
	end if
end tell