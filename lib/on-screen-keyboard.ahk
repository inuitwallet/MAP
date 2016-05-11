
class OnScreenKeyboard {

	onscreen(toggle) {
		if toggle {
			Run, osk.exe
		}
		else {
			while WinExist("ahk_exe osk.exe") {
				WinKill, ahk_exe osk.exe
				sleep 500 
			}
		}
	}
	
	present {
		get {
			if WinExist("ahk_exe osk.exe")
				return 1
			else
				return 0			
		}
	}
	
}