tell application "System Events" to tell process "Skim"
    set frontmost to true
    tell menu bar item "File" of menu bar 1
        click
        click menu item "New From Clipboard" of menu 1
    end tell
end tell