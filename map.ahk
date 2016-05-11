#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
DetectHiddenWindows On

;Include the library files
#Include <accessibility>
#Include <_struct>
#Include <utils>
#Include <magnifier>
#Include <narrator>
#Include <on-screen-keyboard>
#Include <map-portal>

;Install the image files 
FileCreateDir, img 
FileInstall, img\apply_map_settings.png, img\apply_map_settings.png, 1
FileInstall, img\change.png, img\change.png, 1
FileInstall, img\map_portal.png, img\map_portal.png, 1
FileInstall, img\map_portal_save.png, img\map_portal_save.png, 1
FileInstall, img\pen_drive.png, img\pen_drive.png, 1
FileInstall, img\quit.png, img\quit.png, 1

; build unique identifier for this machine
ident := get_pc_ident()

; instantiate the necessary objects
ac := new Accessibility
mag := new Magnifier
osk := new OnScreenKeyboard

; Capture the current config before changing any settings
IniWrite, % ac.MouseSonar, settings.ini, % ident, MouseSonar
IniWrite, % ac.ShowSounds, settings.ini, % ident, ShowSounds
IniWrite, % ac.FocusBorderHeight, settings.ini, % ident, FocusBorder
IniWrite, % mag.present, settings.ini, % ident, Magnifier
IniWrite, % osk.present, settings.ini, % ident, OnScreenKeyboard

; build the simple UI
Gui, Main:+OwnDialogs -Caption +Border
Gui, Main:New
Gui, Main:Color, fff2cc
Gui, Main:Font, s30 ccd9000
Gui, Main:Add, Text, w515 Section Center, MAP Client
Gui, Main:Font, s25
Gui, Main:Add, Picture, xs Section w515 h250 gApplyMapSettings Border, img\apply_map_settings.png
Gui, Main:Add, Text, xs y+-70 w515 BackgroundTrans Center, Apply MAP Settings
Gui, Main:Add, Picture, xs Section w250 h250 gChangeSettings Border, img\change.png
Gui, Main:Add, Text, xs y+-70 w250 BackgroundTrans Center, Change Settings
Gui, Main:Add, Picture, ys Section x+15 w250 h250 gQuit Border, img\quit.png
Gui, Main:Add, Text, xs y+-70 w250 BackgroundTrans Center, Quit
Gui, Main:Show, AutoSize, MAP
Return

BackToMain:
	Gui, MAPLocationChoice:Hide
	Gui, PortalLogin:Hide
	Gui, ChangeSettings:Hide
	Gui, Main:Show
	Return
	
ApplyMapSettings() {
	; This is the UI to show when 'Apply MAP Settings' has been chosen
	; It alllows for a choice of locations to applly the settings from: Portal or USB
	Gui, MAPLocationChoice:New
	Gui, MAPLocationChoice:Color, fff2cc
	if A_Gui = Main
	{
		Gui, Main:Hide
		Gui, MAPLocationChoice:Font, s30 ccd9000
		Gui, MAPLocationChoice:Add, Text, w510 Center gBackToMain, MAP settings Load Location
		Gui, MAPLocationChoice:Font, s25
		Gui, MAPLocationChoice:Add, Picture, xs Section w250 h250 gMapPortalApply Border, img\map_portal.png
		Gui, MAPLocationChoice:Add, Text, xs y+-70 w250 BackgroundTrans Center, MAP Portal
		Gui, MAPLocationChoice:Add, Picture, ys Section w250 h250 Border, img\pen_drive.png
		Gui, MAPLocationChoice:Add, Text, xs y+-70 w250 BackgroundTrans Center, USB Stick
	}
	if A_Gui = ChangeSettings 
	{	
		global MouseSonar, ShowSounds, FocusBorder, Magnifier, OnScreenKeyboard
		Gui, ChangeSettings:Submit
		IniWrite, % MouseSonar, settings.ini, MAPSettings, MouseSonar
		IniWrite, % ShowSounds, settings.ini, MAPSettings, ShowSounds
		IniWrite, % FocusBorder, settings.ini, MAPSettings, FocusBorder
		IniWrite, % Magnifier, settings.ini, MAPSettings, Magnifier
		IniWrite, % OnScreenKeyboard, settings.ini, MAPSettings, OnScreenKeyboard
		Gui, MAPLocationChoice:Font, s30 ccd9000
		Gui, MAPLocationChoice:Add, Text, w510 Center gBackToMain, MAP settings Save Location
		Gui, MAPLocationChoice:Font, s25
		Gui, MAPLocationChoice:Add, Picture, xs Section w250 h250 gMapPortalSave Border, img\map_portal_save.png
		Gui, MAPLocationChoice:Add, Text, xs y+-70 w250 BackgroundTrans Center, MAP Portal
		Gui, MAPLocationChoice:Add, Picture, ys Section w250 h250 Border, img\pen_drive.png
		Gui, MAPLocationChoice:Add, Text, xs y+-70 w250 BackgroundTrans Center, USB Stick
	}
	Gui, MAPLocationChoice:Show, AutoSize, MAP Settings
	Return
}
	
MapPortalApply:
	; If the user  has chosen to apply their MAP settingss fromm the portal this runs
	; We hide the UI and send them to the login form
	Gui, MAPLocationChoice: Hide
	PortalLogin("apply")
	Return
	
MapPortalSave:
	Gui, MAPLocationChoice: Hide
	PortalLogin("save")
	Return
	
ChangeSettings:
	; If the user wants to change their settings we show them this UI
	Gui, Main:Hide
	Gui, ChangeSettings:New
	Gui, ChangeSettings:Color, fff2cc
	Gui, ChangeSettings:Font, s30 ccd9000
	Gui, ChangeSettings:Add, Text, w610 Center gBackToMain, Change MAP settings
	Gui, ChangeSettings:Font, s20
	IniRead, MouseSonar, settings.ini, MAPSettings, MouseSonar, % ac.MouseSonar
	Gui, ChangeSettings:Add, CheckBox, % "Section Checked" . MouseSonar . " w300 vMouseSonar", Mouse Sonar
	IniRead, ShowSounds, settings.ini, MAPSettings, ShowSounds, % ac.ShowSounds
	Gui, ChangeSettings:Add, CheckBox, % "ys Checked" . ShowSounds . " w300 vShowSounds", Show Sounds
	IniRead, Magnifier, settings.ini, MAPSettings, Magnifier, % mag.present
	Gui, ChangeSettings:Add, CheckBox, % "xs Section Checked" . Magnifier . " w300 vMagnifier", Magnifier
	IniRead, OnScreenKeyboard, settings.ini, MAPSettings, OnScreenKeyboard, % osk.present
	Gui, ChangeSettings:Add, CheckBox, % "ys Checked" . OnScreenKeyboard . " w300 vOnScreenKeyboard", On Screen Keyboard
	IniRead, FocusBorder, settings.ini, MAPSettings, FocusBorder, % ac.FocusBorder
	Gui, ChangeSettings:Add, Text, w200 xs Section Right, Focus Border
	Gui, ChangeSettings:Add, Edit, ys-2 w100
	Gui, ChangeSettings:Add, UpDown, vFocusBorder, % FocusBorder
	Gui, ChangeSettings:Add, Button, xs Section w300 gPreviewMAPSettings, Preview
	Gui, ChangeSettings:Add, Button, ys w300 gApplyMapSettings, Save
	Gui, ChangeSettings:Show, AutoSize, MAP Change Settings
	Return

PreviewMAPSettings:
	; Submit the UI and change the settings accordingly
	Gui, ChangeSettings: Submit, NoHide
	ac.MouseSonar := MouseSonar
	ac.ShowSounds := ShowSounds
	mag.magnify(Magnifier)
	osk.onscreen(OnScreenKeyboard)
	ac.FocusBorderHeight := FocusBorder 
	ac.FocusBorderWidth := FocusBorder
	MsgBox, 0, MAP, The settings have been applied, 2
	Return
	
Gui, Close:
Quit:
	; read the original settings from the settings file and apply them
	IniRead, MouseSonar, settings.ini, % ident, MouseSonar
	ac.MouseSonar := MouseSonar
	IniRead, ShowSounds, settings.ini, % ident, ShowSounds
	ac.ShowSounds := ShowSounds
	IniRead, FocusBorderHeight, settings.ini, % ident, FocusBorderHeight
	ac.FocusBorderHeight := FocusBorderHeight
	IniRead, FocusBorderWidth, settings.ini, % ident, FocusBorderWidth
	ac.FocusBorderWidth := FocusBorderWidth
	IniRead, Magnifier, settings.ini, % ident, Magnifier
	mag.magnify(Magnifier)
	IniRead, OnScreenKeyboard, settings.ini, % ident, OnScreenKeyboard
	osk.onscreen(OnScreenKeyboard)
	; remove the image files
	if A_IsCompiled
		FileRemoveDir, img, 1
	MsgBox, 0, MAP, The original settings have been applied on this computer, 3
	ExitApp
	Return