; Helper methods for interacting with the Map Portal

#Include <json>

GetPortalUrl() {

	; Fetch the portal url as set in the settings.ini file and return it
	IniRead, PortalUrl, settings.ini, Portal, PortalUrl
	Return PortalUrl
}

PortalLogin() {
	; Display a UI and allow the user to enter user name and password. 
	; This in turn logs them into the portal and downloads their profile
	global Username, Password
	Gui, PortalLogin:New
	Gui, PortalLogin:Color, fff2cc
	Gui, PortalLogin:Font, s30 ccd9000
	Gui, PortalLogin:Add, Text, w500 Center, MAP Portal Login
	Gui, PortalLogin:Font, s25
	Gui, PortalLogin:Add, Text, w500, Username
	Gui, PortalLogin:Font, cBlack
	Gui, PortalLogin:Add, Edit, w500 vUsername, sammoth
	Gui, PortalLogin:Font, ccd9000
	Gui, PortalLogin:Add, Text, w500, Password 
	Gui, PortalLogin:Font, cBlack
	Gui, PortalLogin:Add, Edit, w500 vPassword password, s4mm0th#?]
	Gui, PortalLogin:Add, Button, w90 Section, Cancel
	Gui, PortalLogin:Add, Button, w300 ys Default, Login
	Gui, PortalLogin:Font, s20 underline
	Gui, PortalLogin:Add, Text, xs cBlue gSignUp, Sign up for a MAP Portal account
	Gui, PortalLogin:Show, Autosize, MAP Portal Login
	Return
	
	PortalLoginButtonCancel:
		Gui, PortalLogin:Hide 
		Gui, Main:Show
		Return
	
	PortalLoginButtonLogin:
		Gui, PortalLogin:Submit
		Gui, PortalLogin:Hide
		profile := GetProfile(Username, Password)
		if (profile.error == "Login Failed")
		{
			Msgbox, 48, Login Failed, Your login failed.`nPlease check your username and password and try again
			Gui, PortalLogin:Show
			Return
		}
		apply := ApplyProfile(profile) 
		Gui, Main:Show
		MsgBox, 0, MAP, Your MAP settings have been applied, 2 
		Return
	
	SignUp:
	Run % GetPortalUrl() . "/signup/"
	Return
}

GetProfile(Username, Password) {
	; Using the supllied credentials, log into the portal and return the profile

	URL := GetPortalUrl() . "/user/" . Username . ".json"

	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	isOpen := WebRequest.Open("GET", URL)
	WebRequest.SetCredentials(Username, Password, 0)
	WebRequest.Send()
	data := JSON_parse(WebRequest.ResponseText)
	if !(data.profile) 
	{
		return Json_parse("{""error"": ""Login Failed""}")
	}
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.Open("GET", data.profile)
	WebRequest.SetCredentials(Username, Password, 0)
	WebRequest.Send()
	return JSON_parse(WebRequest.ResponseText)
}

ApplyProfile(profile) {
	; Apply the given profile
	ac := new Accessibility
	mag := new Magnifier
	osk := new OnScreenKeyboard
	ac.MouseSonar := profile.mouse_sonar
	ac.ShowSounds := profile.show_sounds
	MsgBox % ac.FocusBorderHeight
	ac.FocusBorderHeight := profile.focus_border
	MsgBox % ac.FocusBorderHeight
	ac.FocusBorderWidth := profile.focus_border
	mag.magnify(profile.magnifier)
	osk.onscreen(profile.on_screen_keyboard)
}


