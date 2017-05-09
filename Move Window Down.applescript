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

on approx(a, b)
	set ret to ((a - b) ^ 2) ^ 0.5
	return ret is less than or equal to 10
end approx

on match(windowWidth, windowHeight, w, h)
	set ret to ((windowWidth - (my screenWidth) * w) ^ 2 + (windowHeight - (my screenHeight) * h) ^ 2) ^ 0.5
	return ret is less than or equal to 25
end match

tell application "System Events" to tell (process 1 where frontmost is true)
	set windowResolution to size of the first window
	set windowPos to position of the first window
	set windowWidth to item 1 of windowResolution
	set windowHeight to item 2 of windowResolution
	set windowX to item 1 of windowPos
	set windowY to item 2 of windowPos

	if my approx(windowX, originX) and windowWidth < screenWidth * 0.65 then
		if windowHeight < screenHeight * 0.55 and windowY > originY + screenHeight / 2 then
			set the position of the first window to {originX, originY}
			set the size of the first window to {windowWidth, screenHeight}
		else
			set the size of the first window to {windowWidth, screenHeight / 2}
			set the position of the first window to {originX, originY + screenHeight / 2}
		end if
		return
	end if

	if my approx(windowX + windowWidth, originX + screenWidth) and windowWidth < screenWidth * 0.65 then
		if windowHeight < screenHeight * 0.55 and windowY > originY + screenHeight / 2 then
			set the position of the first window to {windowX, originY}
			set the size of the first window to {windowWidth, screenHeight}
		else
			set the position of the first window to {windowX, originY + screenHeight / 2}
			set the size of the first window to {windowWidth, screenHeight / 2}
		end if
		return
	end if

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
