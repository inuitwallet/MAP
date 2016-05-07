#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
DetectHiddenWindows On

#Include <accessibility>
#Include <_struct>
#Include <utils>
#Include <magnifier>
#Include <narrator>
#Include <on-screen-keyboard>
#Include <map-portal>



; build unique identifier for this machine
ident := get_pc_ident()

; instantiate the necessary objects
ac := new Accessibility
mag := new Magnifier
osk := new OnScreenKeyboard

; Capture the current config before changing any settings
IniWrite, % ac.MouseSonar, settings.ini, % ident, MouseSonar
IniWrite, % ac.ShowSounds, settings.ini, % ident, ShowSounds
IniWrite, % ac.FocusBorderHeight, settings.ini, % ident, FocusBorderHeight
IniWrite, % ac.FocusBorderWidth, settings.ini, % ident, FocusBorderWidth
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
Gui, Main:Add, Picture, xs Section w250 h250 gSave Border, img\save.png
Gui, Main:Add, Text, xs y+-70 w250 BackgroundTrans Center, Save
Gui, Main:Add, Picture, ys Section x+15 w250 h250 Border, img\quit.png
Gui, Main:Add, Text, xs y+-70 w250 BackgroundTrans Center, Quit
Gui, Main:Show, AutoSize, MAP
Return

Gui, Close:
MainButtonQuit:
	; read the original settings from the settings file and apply them
	IniRead, MouseSonar, settings.ini, % ident, MouseSonar
	ac.MouseSonar := MouseSonar
	GuiControl, , MouseSonar, % MouseSonar
	IniRead, Magnifier, settings.ini, % ident, Magnifier
	Magnifier := !mag.present
	GuiControl, , Magnifier, % Magnifier
	ExitApp
	Return
	
ApplyMapSettings:
	Gui, Main:Hide
	Gui, MAPLocationChoice:New
	Gui, MAPLocationChoice:Color, fff2cc
	Gui, MAPLocationChoice:Font, s30 ccd9000
	Gui, MAPLocationChoice:Add, Text, w510 Center, MAP settings Location
	Gui, MAPLocationChoice:Font, s25
	Gui, MAPLocationChoice:Add, Picture, xs Section w250 h250 gMapPortal Border, img\map_portal.png
	Gui, MAPLocationChoice:Add, Text, xs y+-70 w250 BackgroundTrans Center, MAP Portal
	Gui, MAPLocationChoice:Add, Picture, ys Section w250 h250 Border, img\pen_drive.png
	Gui, MAPLocationChoice:Add, Text, xs y+-70 w250 BackgroundTrans Center, USB Stick
	Gui, MAPLocationChoice:Show, AutoSize, MAP Settings
	Return
	
MapPortal:
	;MsgBox, 4161, Map Portal, This will overwrite any settings you currently have saved.
	;IfMsgBox, Cancel 
	;	Return
	Gui, MAPLocationChoice: Hide
	in := PortalLogin()
	Return

	
	
ButtonDownloadSettingsFromMapPortal:
	
	
Save:



ButtonSet:
	; submit the ui and alter the settings accordingly
	Gui, Submit, NoHide
	ac.MouseSonar := MouseSonar
	mag.magnify(Magnifier)
	nar.narrate(Narrator)
	MsgBox, 64, Accessibility Settings, Changes have been applied, 3
	return

ButtonReset:
	; read the original settings from the settings file and apply them
	IniRead, MouseSonar, settings.ini, % ident, MouseSonar
	ac.MouseSonar := MouseSonar
	GuiControl, , MouseSonar, % MouseSonar
	IniRead, Magnifier, settings.ini, % ident, Magnifier
	Magnifier := !mag.present
	mag.magnify(Magnifier)
	GuiControl, , Magnifier, % Magnifier
	IniRead, Narrator, settings.ini, % ident, Narrator
	Narrator := !nar.present
	nar.narrate(Narrator)
	GuiControl, , Narrator, % Narrator
	return

