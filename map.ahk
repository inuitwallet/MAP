#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

#Include <accessibility>
#Include <_struct>
#Include <utils>

ident := get_pc_ident()

ac := new Accessibility

; boolean
IniWrite, % ac.ClientAreaAnimation, settings.ini, % ident, ClientAreaAnimation
IniWrite, % ac.DisableOverlappedContent, settings.ini, % ident, DisableOverlappedContent
IniWrite, % ac.MouseClickLock, settings.ini, % ident, MouseClickLock
IniWrite, % ac.MouseSonar, settings.ini, % ident, MouseSonar
IniWrite, % ac.MouseVanish, settings.ini, % ident, MouseVanish
IniWrite, % ac.ScreenReader, settings.ini, % ident, ScreenReader
IniWrite, % ac.ShowSounds, settings.ini, % ident, ShowSounds

; integers
IniWrite, % ac.FocusBorderHeight, settings.ini, % ident, FocusBorderHeight
IniWrite, % ac.FocusBorderWidth, settings.ini, % ident, FocusBorderWidth
IniWrite, % ac.MessageDuration, settings.ini, % ident, MessageDuration
IniWrite, % ac.MouseClickLockTime, settings.ini, % ident, MouseClickLockTime

Gui, Font, s12
Gui, Add, Text, w500 Section Center, Acessibility Settings
Gui, Font, s11
Gui, Add, Checkbox, % "Checked" . ac.ClientAreaAnimation . " xs w200 Section vClientAreaAnimation", Client Area Animation
Gui, Add, Text, w150 ys Right, Focus Border Height
Gui, Add, Edit, ys-2 w100
Gui, Add, UpDown, vFocusBorderHeight, % ac.FocusBorderHeight
Gui, Add, Checkbox, % "Checked" . ac.DisableOverlappedContent . " xs w200 Section vDisableOverlappedContent", Disable Overlapped Content
Gui, Add, Text, w150 ys Right, Focus Border Width
Gui, Add, Edit, ys-2 w100
Gui, Add, UpDown, vFocusBorderWidth, % ac.FocusBorderWidth
Gui, Add, Checkbox, % "Checked" . ac.MouseClickLock . " xs w200 Section vMouseClickLock", Mouse Click Lock
Gui, Add, Text, w150 ys Right, Message Duration
Gui, Add, Edit, ys-2 w100
Gui, Add, UpDown, vMessageDuration, % ac.MessageDuration
Gui, Add, Checkbox, % "Checked" . ac.MouseSonar . " xs w200 Section vMouseSonar", Mouse Sonar
Gui, Add, Text, w150 ys Right, Mouse Click Lock Time
Gui, Add, Edit, ys-2 w100
Gui, Add, UpDown, vMouseClickLockTime, % ac.MouseClickLockTime
Gui, Add, Checkbox, % "Checked" . ac.MouseVanish . " xs w200 Section vMouseVanish", Mouse Vanish
Gui, Add, Checkbox, % "Checked" . ac.ScreenReader . " xs w200 Section vCScreenReader", Screen Reader
Gui, Add, Checkbox, % "Checked" . ac.ShowSounds . " xs w200 Section vShowSounds", Show Sounds
Gui, Add, Button, xs Section w250, Set
Gui, Add, Button, ys w250, Reset

Gui, Show, AutoSize, MAP
return

Gui, Close:
	ExitApp

ButtonSet:
	Gui, Submit, NoHide
	ac.ClientAreaAnimation := ClientAreaAnimation
	ac.DisableOverlappedContent := DisableOverlappedContent
	ac.MouseClickLock := MouseClickLock
	ac.MouseSonar := MouseSonar
	ac.MouseVanish := MouseVanish
	ac.ScreenReader := ScreenReader
	ac.ShowSounds := ShowSounds
	ac.FocusBorderHeight := FocusBorderHeight
	ac.FocusBorderWidth := FocusBorderWidth
	ac.MessageDuration := MessageDuration
	ac.MouseClickLockTime := MouseClickLockTime
	MsgBox % "Changes have been applied"
	return

ButtonReset:
	IniRead, ClientAreaAnimation, settings.ini, % ident, ClientAreaAnimation
	ac.ClientAreaAnimation := ClientAreaAnimation
	GuiControl, , ClientAreaAnimation, % ClientAreaAnimation
	IniRead, DisableOverlappedContent, settings.ini, % ident, DisableOverlappedContent
	ac.DisableOverlappedContent := DisableOverlappedContent
	GuiControl, , DisableOverlappedContent, % DisableOverlappedContent
	IniRead, MouseClickLock, settings.ini, % ident, MouseClickLock
	ac.MouseClickLock := MouseClickLock
	GuiControl, , MouseClickLock, % MouseClickLock
	IniRead, MouseSonar, settings.ini, % ident, MouseSonar
	ac.MouseSonar := MouseSonar
	GuiControl, , MouseSonar, % MouseSonar
	IniRead, MouseVanish, settings.ini, % ident, MouseVanish
	ac.MouseVanish := MouseVanish
	GuiControl, , MouseVanish, % MouseVanish
	IniRead, ScreenReader, settings.ini, % ident, ScreenReader
	ac.ScreenReader := ScreenReader
	GuiControl, , ScreenReader, % ScreenReader	
	IniRead, ShowSounds, settings.ini, % ident, ShowSounds
	ac.ShowSounds := ShowSounds
	GuiControl, , ShowSounds, % ShowSounds
	IniRead, FocusBorderHeight, settings.ini, % ident, FocusBorderHeight
	ac.FocusBorderHeight := FocusBorderHeight
	GuiControl, , FocusBorderHeight, % FocusBorderHeight
	IniRead, FocusBorderWidth, settings.ini, % ident, FocusBorderWidth
	ac.FocusBorderWidth := FocusBorderWidth
	GuiControl, , FocusBorderWidth, % FocusBorderWidth
	IniRead, MessageDuration, settings.ini, % ident, MessageDuration
	ac.MessageDuration := MessageDuration
	GuiControl, , MessageDuration, % MessageDuration
	IniRead, MouseClickLockTime, settings.ini, % ident, MouseClickLockTime
	ac.MouseClickLockTime := MouseClickLockTime
	GuiControl, , MouseClickLockTime, % MouseClickLockTime
	return

