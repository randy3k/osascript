use framework "CoreGraphics"
use scripting additions
set sizes to item 1 of (current application's NSScreen's mainScreen's visibleFrame as list)
set screenWidth to width of |size| of sizes
set screenHeight to height of |size| of sizes
set originX to x of origin of sizes
set originY to y of origin of sizes

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
