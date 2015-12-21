#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include accessibility.ahk


ac := new Accessibility

;MsgBox % "ClientAreaAnimation = " + ac.ClientAreaAnimation
;ac.ClientAreaAnimation := ! ac.ClientAreaAnimation
;MsgBox % "ClientAreaAnimation = " + ac.ClientAreaAnimation
;
;MsgBox % "DisableOverlappedContent = " + ac.DisableOverlappedContent
;ac.DisableOverlappedContent := !ac.DisableOverlappedContent
;MsgBox % "DisableOverlappedContent = " + ac.DisableOverlappedContent
;
;MsgBox % "FocusBorderHeight = " + ac.FocusBorderHeight
;ac.FocusBorderHeight := 200
;MsgBox % "FocusBorderHeight = " + ac.FocusBorderHeight

MsgBox % ac.HighContrast
;ac.AudioDescription := 1
;MsgBox % ac.AudioDescription