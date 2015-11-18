tell application "Finder"
	activate
	choose folder with prompt "Please choose a folder to import into Photos as an album:"
	set theFolderToImport to the result
	set theFoldersName to the name of theFolderToImport
	set thePhotosToImport to the files of theFolderToImport
	set thePhotosToImportAsAliases to {}
	repeat with b in thePhotosToImport
		set a to b as alias
		set the end of thePhotosToImportAsAliases to a
	end repeat
end tell

tell application "Photos"
	activate
	delay 2
	set theNewAlbum to make new album named theFoldersName
	--import thePhotosToImportAsAliases into theNewAlbum with skip check duplicates
	import thePhotosToImportAsAliases into theNewAlbum
end tell