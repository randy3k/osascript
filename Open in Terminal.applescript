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

set thefolder to (do shell script "cd " & quoted form of thefolder & "; pwd -P") & "/"
set detected to false
--display dialog thefolder

if my appIsRunning("Terminal") then
	tell application "System Events" to tell process "Terminal"
		repeat with w in windows
			try
				set thetitle to name of w
				set termfolder to my urldecode(value of attribute "AXDocument" of w)
				if termfolder is thefolder and (thetitle contains "bash" or thetitle contains "zsh") then
					set detected to true
					perform action "AXRaise" of w
					exit repeat
				end if
			end try
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
