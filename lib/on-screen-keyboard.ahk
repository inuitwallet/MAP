
class OnScreenKeyboard {

	onscreen(toggle) {
		if toggle {
			Run, osk.exe
		}
		else {
			while WinExist("ahk_exe osk.exe") {
				WinKill, ahk_exe osk.exe
			}
		}
	}
	
	present {
		get {
			return WinExist("ahk_exe osk.exe")
		}
	}
	
}