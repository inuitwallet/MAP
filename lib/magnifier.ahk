
class Magnifier {

	magnify(toggle) {
		if toggle {
			Run, magnify.exe
		}
		else {
			while WinExist("ahk_exe Magnify.exe") {
				WinKill, ahk_exe Magnify.exe
			}
		}
	}
	
	present {
		get {
			return WinExist("ahk_exe Magnify.exe")
		}
	}
	
}