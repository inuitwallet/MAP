
class Narrator {

	narrate(toggle) {
		if toggle {
			Run, narrator.exe
		} else {
			while WinExist("ahk_exe Narrator.exe") {
				WinKill, ahk_exe Narrator.exe
			}
		}
	}
	
	present {
		get {
			return WinExist("ahk_exe Narrator.exe")
		}
	}
	
}