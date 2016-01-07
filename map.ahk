#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

#Include <accessibility>
#Include <_struct>
#Include <utils>
#Include <magnifier>
#Include <narrator>

; build unique identifier for this machine
ident := get_pc_ident()

; instantiate the necessary objects
ac := new Accessibility
mag := new Magnifier
nar := new Narrator

; Capture the current config before changing any settings
IniWrite, % ac.MouseSonar, settings.ini, % ident, MouseSonar
IniWrite, % mag.present, settings.ini, % ident, Magnifier
IniWrite, % nar.present, settings.ini, % ident, Narrator

; build the simple UI
Gui, Font, s12
Gui, Add, Text, w500 Section Center, Acessibility Settings
Gui, Font, s11
Gui, Add, Checkbox, % "Checked" . ac.MouseSonar . " xs w160 Section vMouseSonar", Mouse Sonar
Gui, Add, Checkbox, % "Checked" . mag.present . " ys w160 vMagnifier", Magnifier
Gui, Add, Checkbox, % "Checked" . nar.present . " ys w160 vNarrator", Narrator
Gui, Add, Button, xs Section w250, Set
Gui, Add, Button, ys w250, Reset

Gui, Show, AutoSize, MAP
return

Gui, Close:
	ExitApp

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

