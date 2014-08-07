property newLine : (ASCII character 10)

on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning

on sed(srcString, pattern)
	do shell script "echo " & quoted form of srcString & " |" & "sed '" & pattern & "'"
end sed

on urldecode(URLpath)
	set URLpath to do shell script "x=" & quoted form of URLpath & ";x=${x/#file:\\/\\/};x=${x/#localhost}; printf ${x//%/\\\\x}"
	return URLpath
end urldecode

on frontWinDoc(theApp)
	tell application "System Events" to tell process theApp
		set URLpath to value of attribute "AXDocument" of window 1
		return my urldecode(URLpath)
	end tell
end frontWinDoc

on isDirectory(itemPath)
	set fileType to (do shell script "file -b " & quoted form of itemPath)
	if fileType ends with "directory" then return true
	return false
end isDirectory

on frontApp()
	tell application "System Events"
		name of first process whose frontmost is true
	end tell
end frontApp

set thefrontApp to frontApp()

if thefrontApp is "Finder" then
	tell application "Finder"
		try
			set thefolder to (insertion location) as alias
			set thefolder to (POSIX path of thefolder)
		on error
			set thefolder to do shell script "echo ~/"
		end try
	end tell
else if thefrontApp is "Atom" then
	tell application "System Events" to tell process "Atom"
		set thetitle to ((name of window 1) as string)
		set thepath to my sed(thetitle, "s|.* - /|/|")
		if my isDirectory(thepath) then
			set thefolder to thepath & "/"
		else
			set thefolder to (do shell script "dirname " & quoted form of thepath) & "/"
		end if
	end tell
else
	try
		set thefrontWinDoc to frontWinDoc(thefrontApp)
		if thefrontWinDoc is not "missing value" then
			if my isDirectory(thefrontWinDoc) then
				set thefolder to thefrontWinDoc
			else
				set thefolder to (do shell script "dirname " & quoted form of thefrontWinDoc) & "/"
			end if
		else
			set thefolder to do shell script "echo ~/"
		end if
	on error
		set thefolder to do shell script "echo ~/"
	end try
end if

set detected to false
--display dialog thefolder

if my appIsRunning("Terminal") then
	tell application "System Events" to tell process "Terminal"
		repeat with w in windows
			set thetitle to name of w
			set termfolder to my urldecode(value of attribute "AXDocument" of w)
			if termfolder is thefolder and thetitle contains "bash" then
				set detected to true
				perform action "AXRaise" of w
				exit repeat
			end if
		end repeat
	end tell
	tell application "Terminal"
		if detected then
			activate
		else
			do shell script "open -a terminal " & quoted form of thefolder
		end if
	end tell
else
	do shell script "open -a terminal " & quoted form of thefolder
end if

