#include-once

;OnAutoItExitRegister("MyExitFunc")
#include <Date.au3>
#include "constants.au3"

Opt('MustDeclareVars', 1)

#cs ############################################################################

 Small functions section. All functions can be unittested

#ce ############################################################################
; ==================================
; Get names from input
; Return:
; 	- Navn , Etternavn, Fnr
; ==================================

Func GetNames( $input, byref $name, byref $surname, byref $fnr )

	; acceptable format:
	; 	name middle surname ddmmyyxxxxx	- fnr
	;	name middle surname ddmmyy(s) 	- short fdato
	;	name middle surname ddmmyyyy(s)	- long fdato

	; if fnr goes last
	If StringRegExp( $input, "^(\S+ ){2,}(\d{6})((\d\d)?([kKmM]?)|\d{5})$" ) then

		$name    = StringProper( StringRegExpReplace( $input, "^(\S+) (.*)$", "$1" ))
		$surname = StringProper( StringRegExpReplace( $input, "^(.*?) (.*) (.*)$", "$2" ))
		$fnr     = StringRegExpReplace( $input, "^(.*) (\d+.*)$", "$2" )

	; if fnr goes first
	elseif  StringRegExp( $input, "^(\d{6})((\d\d)?([kKmM]?)|\d{5})( \S+){2,}$" ) then

		$name    = StringProper( StringRegExpReplace( $input, "^(\d+.*?) (\S+) (.*)$", "$2" ))
		$surname = StringProper( StringRegExpReplace( $input, "^(\d+.*?) (\S+) (.*)$", "$3" ))
		$fnr     = StringRegExpReplace( $input, "^(\d+.*?) (.*)$", "$1" )

	; if wrong format
	Else
		Return $ERR_FORMAT

	EndIf

	return $ERR_OK

EndFunc

; =============================	=====
; Get Elements
; Return:
; 	- Fnr, Fdato, SexId
; ==================================
Func GetElements( $input, byref $fnr, byref $fdato, byref $sexid )

	; acceptable format:
	; 	ddmmyyxxxxx	- fnr
	;	ddmmyy(s) 	- short fdato
	;	ddmmyyyy(s)	- long fdato

	; if normal fnr/dnr - ddmmyyxxxxx
	If StringRegExp( $input, "^([04][1-9]|[1256][0-9]|[37][01])(0[1-9]|1[012])(\d){7}$") then
			$sexid = 2 - mod( StringMid( $input, 9, 1), 2) ; odd=2, even=1
			$fnr = $input
			$fdato = GetFdato( $input )
			return 0

	; if short fdato - ddmmyy(s)
	elseif StringRegExp( $input, "^(0[1-9]|[12][0-9]|3[01])(0[1-9]|1[012])[0-9][0-9][kKmM]?$") then
			$sexid = GetSexId(  StringRight($input,1) )
			$fnr = StringLeft( $input, 6)
			$fdato = GetFdato( $input )
			return 0

	; if long fdato - ddmmyyyy(s)
	elseif StringRegExp( $input, "^(0[1-9]|[12][0-9]|3[01])(0[1-9]|1[012])\d{4}[kKmM]?$") then
			$sexid = GetSexId(  StringRight($input,1) )
			$fnr = StringRegExpReplace( $input, "(\d\d\d\d)\d\d(\d\d).?", "$1$2")
			$fdato = GetFdato( $input )
			return 0

	EndIf

	; none fits - > wrong format
	Return $ERR_FNR

EndFunc


; -----------------------------------------------------------------------------
; Function: GetVersion
;
; Return: String
;
; -----------------------------------------------------------------------------

Func GetVersion()

	Local $ver
	If @Compiled Then

		$ver = FileGetVersion(@ScriptFullPath, "Timestamp")
		$ver = StringReplace( $ver, "/", "." )
		$ver = StringReplace( $ver, ":", "" )
		$ver = StringLeft( $ver, StringLen($ver)-2 )

	Else

		$ver = "Not compiled"

	EndIf

	Return $ver

EndFunc



; -----------------------------------------------------------------------------
; Function: StringProper
; -----------------------------------------------------------------------------
Func StringProper($s_String)
	Local $iX = 0
	Local $CapNext = 1
	Local $s_nStr = ""
	Local $s_CurChar
	For $iX = 1 To StringLen($s_String)
		$s_CurChar = StringMid($s_String, $iX, 1)
		Select
			Case $CapNext = 1
				If StringRegExp($s_CurChar, '[a-zA-Z0-9' & ChrW(198) & ChrW(230) & ChrW(216) & ChrW(248) & ChrW(197) & ChrW(229) & ']') Then
					$s_CurChar = StringUpper($s_CurChar)
					$CapNext = 0
				EndIf
			Case Not StringRegExp($s_CurChar, '[a-zA-Z0-9' & ChrW(198) & ChrW(230) & ChrW(216) & ChrW(248) & ChrW(197) & ChrW(229) & ']')
				$CapNext = 1
			Case Else
				$s_CurChar = StringLower($s_CurChar)
		EndSelect
		$s_nStr &= $s_CurChar
	Next
	Return $s_nStr
EndFunc ;==>StringProper

; ==================================
; Get century from fnr/dnr
; Return:
; 	0 - error - feil fnr
; 	1800,1900,2000 - otherwise
; Unit test:
; 	ut_GetCentury.au3
; ==================================
Func GetCentury( $fnr )
Local $pers = StringMid( $fnr, 7,3)
Local $yy = StringMid( $fnr, 5,2)
	; Check Alder
	; 000-499 - 1900
	; 500-749 - 1854-1899
	; 500-999 - 2000-2039
	; 900-999 - 1940-1999

	If $pers < 500 Then
		return 19
	ElseIf $yy < 40 Then
		return 20
	ElseIf $pers > 899 Then
		return 19
	ElseIf $pers < 750 and $yy > 53 Then
		return 18
	Else
		Return 0
	EndIf


EndFunc

; ==================================
; Get Sex name from sexid
; Return:
; 	sex name
;
; Unit test:
; 	ut_GetSexName.au3
; ==================================

Func GetSexName( $sexid )
	Local $sex

	switch $sexid
		case $SEX_MANN
			$sex = "Mann"
		case $SEX_KVINNE
			$sex = "Kvinne"
		case Else
			$sex = "Ukjent"
	EndSwitch

	Return $sex
EndFunc

; ==================================
; Get SexId from letter
; Return:
; 	sexid
;
; Unit test:
; 	ut_GetSexId.au3
; ==================================
Func GetSexId( $sSex )
	Local $id

	Switch StringUpper( $sSex  )
		case "M"
			$id = $SEX_MANN
		case "K"
			$id = $SEX_KVINNE
		case else
			$id = $SEX_UKJENT
	endswitch
	Return $id
EndFunc

; ==================================
; Get GUID
; Return:
; 	- uniq GUID
; ==================================
Func GetGUID()
	Local $id
	Local $oScriptlet = ObjCreate("Scriptlet.TypeLib")

	$id = $oScriptlet.Guid
	$id = StringMid($id, 2, StringLen($id) - 2)
	Return $id
EndFunc   ;==> GetGUID

; ==================================
; Check it is dnr
; Return: true=dnr/ false-fnr
; Unit test:
; 	ut_isDnr.au3
; ==================================
Func isDnr( $fnr)
	Return StringRegExp( $fnr, "^(4[1-9]|[56][0-9]|7[01])" )
EndFunc

; ==================================
; Get Fdato
; Input:
; 	ddmmyy
;	ddmmyyyy
;	ddmmyy00000

; Return:
; 	- fdato string yyyy-mm-dd
; ==================================
Func GetFdato( $fnr )

	Local $fdato

		; ddmmyy00000 - fnr&dnr
		if StringRegExp( $fnr, "^\d{11}$" ) then

			; check if dnr
			if isDnr( $fnr ) then
				$fnr = String(StringLeft( $fnr, 1)-4) & StringMid($fnr, 2, 10)
			Endif

			$fdato = StringRegExpReplace( $fnr, "^(\d\d)(\d\d)(\d\d)\d*", GetCentury($fnr) & "$3-$2-$1" )

		; ddmmyyyy - long fdato
		elseif StringRegExp( $fnr, "^\d{8}\D?$" ) then

			$fdato = StringRegExpReplace( $fnr, "(\d\d)(\d\d)(\d\d\d\d)\D?", "$3-$2-$1")

		; ddmmyy - short fdato
		elseif StringRegExp( $fnr, "^\d{6}\D?$" ) then

			$fdato = StringRegExpReplace( $fnr, "^(\d\d)(\d\d)(\d\d)\D?", "$3-$2-$1")

			; if fnr.year >= now.year then 1900, else 2000
			if StringMid( $fnr, 5,2) >= StringMid( _NowCalc(), 3,2) then
				$fdato = "19" & $fdato
			Else
				$fdato = "20" & $fdato
			EndIf

		else
			return -1
		EndIf

	Return $fdato

EndFunc

; ==================================
; Get Age
; Return:
; 	- Age
; ==================================
Func GetAge( $fdato )

	Local $age
	Local $yyyy, $mm, $dd

	$yyyy	= StringLeft($fdato, 4)
	$mm 	= StringMid( $fdato, 6, 2)
	$dd 	= StringMid( $fdato, 9, 2)

	$age = _DateDiff("Y", $yyyy & "/" & $mm & "/" & $dd, _NowCalc())
	if @error <> 0 Then
		Return -1
	EndIf

	Return $age

EndFunc


; ===================================
; Handle Error message
; ===================================

func FlagError( $err, $text = "", $flag = 0 )

	switch $err
		case $ERR_OK
			return
		case $ERR_FORMAT
			$text = "name surname fnr"
		case $ERR_FNR
			$text = "ugyldig fødslesnummer"
		case $ERR_FDATO
			$text = "ugyldig fødslesdato"
		case $ERR_OPEN_FILE
			$text = "Can't open file " & $text
		case $ERR_READ_FILE
			$text = "Can't read file " & $text
		case $ERR_WRITE_FILE
			$text = "Can't write file " & $text
		case $ERR_OVERWRITE
			$text = "File " & $text & " alredy exists. Overwite? "
		case Else
			$text = "Unknown error"

	EndSwitch

	return MsgBox( $flag, "Error "& $err , $text )

EndFunc

; ===================================
; Handle Text case
; ===================================
Global $typetext = 0; 0 - Proper, 1- Uppercase

Func SetTextUpper()
	$typetext = 1
	return 0
EndFunc

Func SetTextProper()
	$typetext = 0
	return 0
EndFunc

Func isTextUpper()
	return $typetext
EndFunc
