
class Magnifier {

	magnify(toggle) {
		if toggle {
			Run, magnify.exe
		}
		else {
			while WinExist("ahk_exe Magnify.exe") {
				WinKill, ahk_exe Magnify.exe
				Sleep 500 
			}
		}
	}
	
	present {
		get {
			if WinExist("ahk_exe Magnify.exe")
				return 1
			else
				return 0
		}
	}
	
}