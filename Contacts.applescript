on sed(srcString, pattern)
	do shell script "echo " & quoted form of srcString & " |" & "sed '" & pattern & "'"
end sed

tell application "Contacts"
	set chg to "Yes"
	set formatfb to button returned of (display dialog ("Remove Social Profiles?") as string buttons {"Yes", "No"} default button 2 with title "Confirm")
	set formatpn to button returned of (display dialog ("Format Phone number?" & return & "This can be slow") as string buttons {"Yes", "No"} default button 2 with title "Confirm")
	
	if formatfb is "Yes" or formatpn is "Yes" then
		repeat with thePerson in people
			
			set icloud to false
			repeat with g in (name of groups of thePerson as list)
				if g contains "card" then
					set icloud to true
					exit repeat
				end if
			end repeat
			if icloud is false then
				
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
					repeat with thePhone in phone of thePerson
						set phonenum to ((value of thePhone) as string)
						
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
									set personinfo to personinfo & return & areacode & " " & phonenum & "?"
									set chg to button returned of (display dialog {personinfo} as string buttons {"Yes", "Yes to all", "No"} default button 3 with title "Change the following number?")
									if chg is not "No" then set phonenum to areacode & phonenum
								else
									set phonenum to areacode & phonenum
								end if
							end if
						end if
						
						set value of thePhone to phonenum
					end repeat
				end if
			end if
		end repeat
	end if
	display dialog "Finish"
	save
end tell