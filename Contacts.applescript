property newLine : (ASCII character 10)

on sed(srcString, pattern)
	do shell script "echo " & quoted form of srcString & " |" & "sed '" & pattern & "'"
end sed

tell application "Contacts"
	activate
	set peopleCount to (count every person)
	set chg to "Yes"
	set formatfb to button returned of (display dialog ("Remove Social Profiles?") as string buttons {"Yes", "No"} default button 2 with title "Confirm")
	set formatpn to button returned of (display dialog ("Format Phone number?" & newLine & "This can be slow") as string buttons {"Yes", "No"} default button 2 with title "Confirm")
	
	if formatfb is "Yes" or formatpn is "Yes" then
		repeat with i from 1 to peopleCount
			set phoneCount to (count every phone of person i)
			set thePerson to person i
			
			# reformat contact info
			if formatfb is "Yes" then
				if not company of thePerson then
					delete organization of thePerson
					delete job title of thePerson
				end if
				delete url of thePerson
				delete birth date of thePerson
				delete (user name of every social profile of thePerson)
				set (service name of every social profile of thePerson) to ""
				set url of every social profile of thePerson to ""
				delete address of thePerson
				--delete image of thePerson
			end if
			
			-- format phone number
			if formatpn is "Yes" then
				repeat with j from 1 to phoneCount
					set thephone to phone j of thePerson

					set phonenum to ((value of thephone) as string)
					
					# reformat the number
					set phonenum to my sed(phonenum, "s/[ ()\\-]//g")
					
					# add area code
					if character 1 of phonenum is not "+" then
						set areacode to ""
						if length of phonenum is 8 then
							set areacode to "+852"
						else if length of phonenum is 10 then
							set areacode to "+1"
						else if length of phonenum is 11 then
							set areacode to "+86"
						end if
						if areacode is not "" then
							if chg is not "Yes to all" then
								set personinfo to "Name: " & first name of thePerson & " " & last name of thePerson
								if organization of thePerson is not missing value then
									set personinfo to personinfo & newLine & "Company: " & organization of thePerson
								end if
								set personinfo to personinfo & newLine & areacode & " " & phonenum & "?"
								set chg to button returned of (display dialog {personinfo} as string buttons {"Yes", "Yes to all", "No"} default button 3 with title "Change the following number?")
								if chg is not "No" then set phonenum to areacode & phonenum
							else
								set phonenum to areacode & phonenum
							end if
						end if
					end if
					
					set value of thephone to phonenum
				end repeat
			end if
		end repeat
	end if
	display dialog "Finish"
	save
end tell