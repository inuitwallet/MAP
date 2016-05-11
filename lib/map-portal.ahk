; Helper methods for interacting with the Map Portal

#Include <json>

GetPortalUrl() {

	; Fetch the portal url as set in the settings.ini file and return it
	IniRead, PortalUrl, settings.ini, Portal, PortalUrl
	Return PortalUrl
}

PortalLogin(action) {
	; Display a UI and allow the user to enter user name and password. 
	; This in turn logs them into the portal and downloads their profile
	global Username, Password
	Gui, PortalLogin:New
	Gui, PortalLogin:Color, fff2cc
	Gui, PortalLogin:Font, s30 ccd9000
	Gui, PortalLogin:Add, Text, w500 Center gBackToMain, MAP Portal Login
	Gui, PortalLogin:Font, s25
	Gui, PortalLogin:Add, Text, w500, Username
	Gui, PortalLogin:Font, cBlack
	Gui, PortalLogin:Add, Edit, w500 vUsername
	Gui, PortalLogin:Font, ccd9000
	Gui, PortalLogin:Add, Text, w500, Password 
	Gui, PortalLogin:Font, cBlack
	Gui, PortalLogin:Add, Edit, w500 vPassword password
	if action = apply 
	{
		Gui, PortalLogin:Add, Button, w500 xs Default gLoginAndApply, Login
	}
	if action = save
	{
		Gui, PortalLogin:Add, Button, w500 xs Default gLoginAndSave, Login
	}
	Gui, PortalLogin:Font, s20 underline
	Gui, PortalLogin:Add, Text, xs cBlue gSignUp, Sign up for a MAP Portal account
	Gui, PortalLogin:Show, Autosize, MAP Portal Login
	Return
	
	LoginAndApply:
		Gui, PortalLogin:Submit
		Gui, PortalLogin:Hide
		profile := GetProfile(Username, Password)
		if (profile.error == "Login Failed")
		{
			Msgbox, 48, Login Failed, Your login failed.`nPlease check your username and password and try again
			Gui, PortalLogin:Show
			Return
		}
		FixProfile(profile)
		ApplyProfile(profile) 
		Gui, Main:Show
		MsgBox, 0, MAP, Your MAP settings have been applied, 2 
		Return
		
	LoginAndSave:
		Gui, PortalLogin:Submit
		Gui, PortalLogin:Hide
		save := SaveProfile(Username, Password)
		if (save.error == "Login Failed")
		{
			Msgbox, 48, Login Failed, Your login failed.`nPlease check your username and password and try again
			Gui, PortalLogin:Show
			Return
		}
		Gui, Main:Show
		MsgBox, 0, MAP, Your MAP settings have been saved, 2 
		Return
	
	SignUp:
	Run % GetPortalUrl() . "/signup/"
	Return
}

FixProfile(profile) {
	; alter some values
	for key, value in profile
		Msgbox % key . " " . value
	for key, value in profile {
		if value = -1
			profile[key] := 1
	}
	for key, value in profile
		Msgbox % key . " " . value
}

GetProfileUrl(Username, Password) {
	; get the profile url for the supplied user
	URL := GetPortalUrl() . "/user/" . Username . ".json"

	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	isOpen := WebRequest.Open("GET", URL)
	WebRequest.SetCredentials(Username, Password, 0)
	WebRequest.Send()
	return JSON_parse(WebRequest.ResponseText)
}

GetProfile(Username, Password) {
	; Using the supllied credentials, log into the portal and return the profile
	user := GetProfileUrl(Username, Password)
	if !(user.profile) 
	{
		return Json_parse("{""error"": ""Login Failed""}")
	}
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.Open("GET", user.profile)
	WebRequest.SetCredentials(Username, Password, 0)
	WebRequest.Send()
	return JSON_parse(WebRequest.ResponseText)
}

ApplyProfile(profile) {
	; Apply the given profile
	; Save the profile to the MAP settings too
	ac := new Accessibility
	mag := new Magnifier
	osk := new OnScreenKeyboard
	ac.MouseSonar := profile.mouse_sonar
	IniWrite, % profile.mouse_sonar, settings.ini, MAPSettings, MouseSonar
	ac.ShowSounds := profile.show_sounds
	IniWrite, % profile.show_sounds, settings.ini, MAPSettings, ShowSounds
	ac.FocusBorderHeight := profile.focus_border
	ac.FocusBorderWidth := profile.focus_border
	IniWrite, % profile.focus_border, settings.ini, MAPSettings, FocusBorder
	mag.magnify(profile.magnifier)
	IniWrite, % profile.magnifier, settings.ini, MAPSettings, Magnifier
	osk.onscreen(profile.on_screen_keyboard)
	IniWrite, % profile.on_screen_keyboard, settings.ini, MAPSettings, OnScreenKeyboard
}

SaveProfile(Username, Password) {
	; Post the profile data to the portal
	user := GetProfileUrl(Username, Password)
	if !(user.profile) 
	{
		return Json_parse("{""error"": ""Login Failed""}")
	}
	IniRead, MouseSonar, settings.ini, MAPSettings, MouseSonar, % ac.MouseSonar
	IniRead, ShowSounds, settings.ini, MAPSettings, ShowSounds, % ac.ShowSounds
	IniRead, Magnifier, settings.ini, MAPSettings, Magnifier, % mag.present
	IniRead, OnScreenKeyboard, settings.ini, MAPSettings, OnScreenKeyboard, % osk.present
	IniRead, FocusBorder, settings.ini, MAPSettings, FocusBorder, % ac.FocusBorder
	data := "{""mouse_sonar"": " . MouseSonar . ", ""focus_border"": " . FocusBorder . ", ""magnifier"": " . Magnifier . ", ""on_screen_keyboard"": " . OnScreenKeyboard . "}"
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.Open("PUT", user.profile)
	WebRequest.SetCredentials(Username, Password, 0)
	WebRequest.SetRequestHeader("Content-Type", "application/json")
	WebRequest.Send(data)
	return JSON_parse(WebRequest.ResponseText)
}
