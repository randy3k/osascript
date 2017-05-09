use framework "AppKit"
use scripting additions

on getMainScreen()
	set nss to current application's NSScreen
	repeat with sc in nss's screens()
		set f to sc's frame()
		if f's origin's x is 0 and f's origin's y is 0 then
			return sc
		end if
	end repeat
	return 0
end getMainScreen

set sizes0 to item 1 of (current application's NSScreen's mainScreen's frame as list)
set actualWidth to width of |size| of sizes0
set actualHeight to height of |size| of sizes0
set sizes to item 1 of (current application's NSScreen's mainScreen's visibleFrame as list)
set screenWidth to width of |size| of sizes
set screenHeight to height of |size| of sizes
set originX to x of origin of sizes
set originY to (my getMainScreen()'s frame()'s |size|'s height) - (y of origin of sizes) - screenHeight


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
