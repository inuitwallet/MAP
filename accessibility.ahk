
class Accessibility {

	static SPI_GETACCESSTIMEOUT := 0x003C
	static SPI_SETACCESSTIMEOUT := 0x003D
	static SPI_GETAUDIODESCRIPTION := 0x0074
	static SPI_SETAUDIODESCRIPTION := 0x0075
	static SPI_GETCLIENTAREAANIMATION := 0x1042
	static SPI_SETCLIENTAREAANIMATION := 0x1043
	static SPI_GETDISABLEOVERLAPPEDCONTENT := 0x1040
	static SPI_SETDISABLEOVERLAPPEDCONTENT := 0x1041
	static SPI_GETFILTERKEYS := 0x0032
	static SPI_SETFILTERKEYS := 0x0033
	static SPI_GETFOCUSBORDERHEIGHT := 0x2010
	static SPI_SETFOCUSBORDERHEIGHT := 0x2011
	static SPI_GETFOCUSBORDERWIDTH := 0x200E
	static SPI_SETFOCUSBORDERWIDTH := 0x200F
	static SPI_GETHIGHCONTRAST := 0x0042
	static SPI_SETHIGHCONTRAST := 0x0043
	static SPI_GETLOGICALDPIOVERRIDE := 0x009E
	static SPI_SETLOGICALDPIOVERRIDE := 0x009F
	static SPI_GETMESSAGEDURATION := 0x2016
	static SPI_SETMESSAGEDURATION := 0x2017
	static SPI_GETMOUSECLICKLOCK := 0x101E
	static SPI_SETMOUSECLICKLOCK := 0x101F
	static SPI_GETMOUSECLICKLOCKTIME := 0x2008
	static SPI_SETMOUSECLICKLOCKTIME := 0x2009
	static SPI_GETMOUSEKEYS := 0x0036
	static SPI_SETMOUSEKEYS := 0x0037
	static SPI_GETMOUSESONAR := 0x101C
	static SPI_SETMOUSESONAR := 0x101D
	static SPI_GETMOUSEVANISH := 0x1020
	static SPI_SETMOUSEVANISH := 0x1021
	static SPI_GETSCREENREADER := 0x0046
	static SPI_SETSCREENREADER := 0x0047
	static SPI_GETSERIALKEYS := 0x003E
	static SPI_SETSERIALKEYS := 0x003F
	static SPI_GETSHOWSOUNDS := 0x0038
	static SPI_SETSHOWSOUNDS := 0x0039
	static SPI_GETSOUNDSENTRY := 0x0040
	static SPI_SETSOUNDSENTRY := 0x0041
	static SPI_GETSTICKYKEYS := 0x003A
	static SPI_SETSTICKYKEYS := 0x003B
	static SPI_GETTOGGLEKEYS := 0x0034
	static SPI_SETTOGGLEKEYS := 0x0035
	static SPIF_UPDATEINIFILE := 0x01
	static SPIF_SENDCHANGE := 0x02
	
	static AUDIODESCRIPTIONSTRUCT_SIZE := 24
	static HIGHCONTRASTSTRUCT_SIZE := 240
	
	; run the DLL Call for the single param to get the value
	single_get(uiAction) {
		if !DllCall("SystemParametersInfo", Uint, uiAction, UInt, 0, UIntP, value, Uint, 0) {
			return "CALL_FAILED"
		}
		return value	
	}
	
	; run the DLL Call for the single param to set the value
	single_set(uiAction, value) {
		if !DllCall("SystemParametersInfo", UInt, uiAction, UInt, 0, Ptr, value, UInt, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE) {
			return "CALL_FAILED"
		}
		return "SUCCESS"
	}
	
	; run the Dll Call for a struct to get the values
	struct_get(uiAction, struct, struct_size) {
		DllCall("SystemParametersInfo", UInt, uiAction, UInt, struct_size, Ptr, &struct, Uint, 0)
		;MsgBox % ErrorLevel		
		return struct
	}
	
	struct_set(uiAction, struct, struct_size) {
		DllCall("SystemParametersInfo", UInt, uiAction, UInt, struct_size, Ptr, &struct, UInt, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE)
		MsgBox % ErrorLevel
		return "SUCCESS"
	}
	
	build_highcontrast_struct() {
		; UINT   cbSize; 4
		; DWORD  dwFlags; 4
		; LPTSTR lpszDefaultScheme; 16
		VarSetCapacity(HCS, this.HIGHCONTRASTSTRUCT_SIZE, 0)
		NumPut(this.HIGHCONTRASTSTRUCT_SIZE, HCS, 0, "UInt")
		return HCS
	}
	
	HighContrast {
		get {
			struct := this.struct_get(this.SPI_GETHIGHCONTRAST, this.build_highcontrast_struct(), this.HIGHCONTRASTSTRUCT_SIZE)
			MsgBox % "cbSize = " + NumGet(&struct + 0, "UInt")
			MsgBox % "dwFlags = " + NumGet(&struct + 4, "UInt")
			MsgBox % "lpszDefaultScheme = " + StrGet(&struct + 8, "UItn")
		}
		set {
		
		}
	}
	
	build_audiodescription_struct() {
		; UINT cbSize; 4
		; BOOL Enabled; 4
		; LCID Locale; 16
		VarSetCapacity(ADS, this.AUDIODESCRIPTIONSTRUCT_SIZE, 0)
		; cbSize offset = 0
		NumPut(this.AUDIODESCRIPTIONSTRUCT_SIZE, ADS, 0, "UInt")
		return ADS
	}
	
	; get Determines whether audio descriptions are enabled or disabled
	; set
	; Windows Server 2003 and Windows XP/2000:  This parameter is not supported.
	AudioDescription {
		get {
			struct := this.struct_get(this.SPI_GETAUDIODESCRIPTION, this.build_audiodescription_struct(), this.AUDIODESCRIPTIONSTRUCT_SIZE)
			;MsgBox % "cbSize = " + NumGet(&struct + 0, "UInt")
			MsgBox % "Enabled = " + NumGet(&struct + 4, "UInt")
			;MsgBox % "Locale = " + StrGet(&struct + 8, "UItn")
		}
		set {
			struct := this.build_audiodescription_struct
			NumPut(1, struct, 4, "Int")
			this.struct_set(this.SPI_SETAUDIODESCRIPTION, struct, this.AUDIODESCRIPTIONSTRUCT_SIZE)
		}
	}
	
	; get Retrieves the height, in pixels, of the top and bottom edges of the focus rectangle drawn with DrawFocusRect.
	; set Sets the height of the top and bottom edges of the focus rectangle drawn with DrawFocusRect to the value of the pvParam parameter.
	; Windows 2000:  This parameter is not supported.
	FocusBorderHeight {
		get {
			return this.single_get(this.SPI_GETFOCUSBORDERHEIGHT)
		}
		set {
			return this.single_set(this.SPI_SETFOCUSBORDERHEIGHT, value)
		}
	}
	
	; get Determines whether overlapped content is enabled or disabled.
	; set Turns overlapped content (such as background images and watermarks) on or off. 
	; Windows Server 2003 and Windows XP/2000:  This parameter is not supported.
	DisableOverlappedContent {
		get {
			return this.single_get(this.SPI_GETDISABLEOVERLAPPEDCONTENT)
		}
		set {
			return this.single_set(this.SPI_SETDISABLEOVERLAPPEDCONTENT, value)
		}
	}
	
	; get Determines whether animations are enabled or disabled. 
	; set Turns client area animations on or off.
	; Windows Server 2003 and Windows XP/2000:  This parameter is not supported.
	ClientAreaAnimation {
		get {
			return this.single_get(this.SPI_GETCLIENTAREAANIMATION)
		}
		set {
			return this.single_set(this.SPI_SETCLIENTAREAANIMATION, value)
		}
	}
}

