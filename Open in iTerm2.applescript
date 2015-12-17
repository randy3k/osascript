-- for iTerm 2.9

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

on pwd_tty(tty_name)
	-- Based on http://genbastechthoughts.wordpress.com/2012/07/10/how-to-duplicate-an-iterm-tab-using-applescript/
	set pid to do shell script ("ps -f | grep " & tty_name & " | head -n 1 | awk '{ print $2; }'")
	set ret to do shell script ("lsof -a -d cwd -F n -p " & pid & " | egrep -v 'p[0-9]+' | awk '{ sub(/^n/, \"\"); print; }'")
	return ret
end pwd_tty

on zshIsCurrent(tty_name)
	(length of (do shell script "ps -O tty | grep S*+ | grep zsh | grep " & tty_name & "|| true")) > 0
end zshIsCurrent

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
set done to false
--display dialog thefolder

set iTermIsRunning to my appIsRunning("iTerm2")
if iTermIsRunning then
	tell application "iTerm"
		repeat with w in windows
			set ntabs to the count (tabs of w)
			if ntabs is 0 then exit repeat
			repeat with i from ntabs to 1 by -1
				set t to item i of tabs of w
				repeat with s in sessions of item i of tabs of w
					set the_name to get name of s
					set tty_name to do shell script "basename " & (get tty of s)
					set working_dir to my pwd_tty(tty_name)
					log working_dir
					log thefolder
					log the_name
					log tty_name
					if working_dir & "/" is thefolder and my zshIsCurrent(tty_name) then
						activate
						select item i of tabs of w
						select s
						if (count of windows) > 1 then
							delay 0.2
							tell application "System Events"
								tell process "iTerm2"
									set frontmost to true
									perform action "AXRaise" of (first window whose title is the_name)
								end tell
							end tell
						end if
						set done to true
						exit repeat
					end if
					if done then exit repeat
				end repeat
				if done then exit repeat
			end repeat
		end repeat
	end tell
end if

log done
if not done then
	tell application "iTerm"
		if (count of (windows)) is 0 then
			create window with default profile
		else
			if iTermIsRunning then tell current window to create tab with default profile
		end if
		tell current window to tell the current session
			write text "cd " & (do shell script "printf %q " & quoted form of thefolder)
		end tell
	end tell
end if
