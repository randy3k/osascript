on gui_scripting_status()
	tell application "System Events"
		set ui_enabled to UI elements enabled
	end tell
	if ui_enabled is false then
		tell application "System Preferences"
			activate
			set current pane to pane id "com.apple.preference.universalaccess"
			display dialog "The GUI scripting architecture of Mac OS X is currently disabled." & return & return & "To activate GUI Scripting select the checkbox \"Enable access for assistive devices\" in the Universal Access preference pane." with icon 1 buttons {"Okay"} default button 1
		end tell
	end if
	return ui_enabled
end gui_scripting_status

on click_menu(app_name, menu_name, menu_item)
	try
		tell application app_name
			activate
		end tell
		tell application "System Events"
			click menu item menu_item of menu menu_name of menu bar 1 of process app_name
		end tell
		return true
	on error error_message
		return false
	end try
end click_menu

on frontApp()
	tell application "System Events"
		name of first process whose frontmost is true
	end tell
end frontApp

set thefrontApp to frontApp()

if gui_scripting_status() then
	click_menu(thefrontApp, "Window", "Merge All Windows")
end if