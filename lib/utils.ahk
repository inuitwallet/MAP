
; Calculate MD% hash of passed data
MD5( ByRef V, L=0 ) {
	VarSetCapacity( MD5_CTX,104,0 ), DllCall( "advapi32\MD5Init", Str,MD5_CTX ) 
	DllCall( "advapi32\MD5Update", Str,MD5_CTX, Str,V, UInt,L ? L : VarSetCapacity(V) ) 
	DllCall( "advapi32\MD5Final", Str,MD5_CTX ) 
	Loop % StrLen( Hex:="123456789ABCDEF0" ) 
		N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1) 
	Return MD5 
}

; calcualte unique identifiwer for this user/computer
get_pc_ident() {
	PC_ident_string := A_UserName . A_ComputerName . A_OSType . A_OSVersion . A_IPAddress1
	return MD5(PC_ident_string, StrLen(PC_ident_string))
}