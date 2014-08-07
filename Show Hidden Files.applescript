set buttonpressed to button returned of (display dialog "Show Hidden Files..." buttons {"Yes", "No"} default button 1)

try
	if the buttonpressed is "No" then do shell script Â
		"defaults write com.apple.finder AppleShowAllFiles OFF"
	if the buttonpressed is "Yes" then do shell script Â
		"defaults write com.apple.finder AppleShowAllFiles ON"
end try
tell application "Finder" to quit
delay 1
tell application "Finder" to activate
