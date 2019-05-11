
; ================================
;
; Simple module to get create xml file from the name and fnr
;
; Versions:
; 13/04/19 - initial prototype
; 15/04/19 v1. ==========
; 17/04/19 - added change filename register by right click
; 23/04/19 - Fixed bugs
;	  - Sex now identifed correctly - by 9th digit (was by 7th)
; 	- When cancel file overwrite return to edit (was Exit from program)
; 	- Write to file in Unocode mode.Can handle norwegian chars (was in Ascii)
;	- Replaced StringProper to work correctly with norwegian chars
; 26/04/19
;	  - changed verification algorithms to RegEx
;	  - added pasient with only f.dato: ddmmyy(k|m), ddmmyyyy(k|m),
; 27/04/19 - added tooltip with examples
; 28/04/19 - added version number in title (dd.mm.yy.hhmm)
; 30/04/19 v2. ==========
; 	- redesigned with functions front/backend
; 	- added unit testing
;	- added support for ddmmyyyy(s)
; 	- added automatic centure for ddmmyy (if fnr.year < now.year -> 1900, otherwise 2000
; 12/05/19
;	- fixed error "no auto_.xml"
; 	- fixed error in error text "fødselsnummer", "fødselsdato"
;	- fiexed proper in names with numbers
;	- remove FNR element for files with fdato
;	- added unit and system testing
; ================================

;OnAutoItExitRegister("MyExitFunc")
#include <Date.au3>
#include <GUIConstantsEx.au3>
;#include <WindowsConstants.au3>

#include "constants.au3"
#include "nypasient2lib.au3"

Opt('MustDeclareVars', 1)

#AutoIt3Wrapper_Res_Field = Timestamp|%date%.%time%


Global $ctrlFile, $ctrlName, $contextmenu, $properItem, $upperItem
Local $msg


GUI_Create()

Do

	$msg = GUIGetMsg()

	Switch $msg

		Case $ctrlName

			ProcessInput(  )

		Case $GUI_EVENT_SECONDARYDOWN

			ProcessMouse()

	EndSwitch

Until $msg = $GUI_EVENT_CLOSE

GUIDelete()

Exit
#cs
; -----------------------------------------------------------------------------
; Function: GetVersion
;
; Return: String
;
; -----------------------------------------------------------------------------
#AutoIt3Wrapper_Res_Field = Timestamp|%date%.%time%

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
#ce

; -----------------------------------------------------------------------------
; Function: Process input
; Input: String
;
; -----------------------------------------------------------------------------
Func GUI_Create()

	; Create input

	GUICreate( "Create new pasient - " & GetVersion(), 480, 50)

	; Label
	$ctrlFile = GUICtrlCreateLabel("PASIENT", 10, 16)
	GUICtrlSetData($ctrlFile ,"Pasient")


	; Label context menu for file name case change
	$contextmenu = GUICtrlCreateContextMenu($ctrlFile)
	$properItem = GUICtrlCreateMenuItem("Navn Etternavn", $contextmenu)
	$upperItem = GUICtrlCreateMenuItem("NAVN ETTERNAVN", $contextmenu)

	; input text with tooltip
	$ctrlName = GUICtrlCreateInput("navn etternavn f.nr", 60, 8, 400, 30 )
	GUICtrlSetTip(-1, "name [middlename] surname fnr/dnr")
	GUICtrlSetFont( $ctrlName, 14, 600 )

	; set focus
	GUICtrlSetState($ctrlName, $GUI_FOCUS)

	; start GUI
	GUISetState() ; will display an empty dialog box

EndFunc


; -----------------------------------------------------------------------------
; Function: Process mouse click
;
;
; -----------------------------------------------------------------------------
Func ProcessMouse()

	; Run the GUI until the dialog is closed
	While 1

		Switch GUIGetMsg()

			Case $properItem
				setTextProper()
				GUICtrlSetData($ctrlFile, StringProper(GUICtrlRead($ctrlFile)))
				ExitLoop
			Case $upperItem
				setTextUpper()
				GUICtrlSetData($ctrlFile, StringUpper(GUICtrlRead($ctrlFile)))
				ExitLoop
		EndSwitch

	WEnd

EndFunc

; -----------------------------------------------------------------------------
; Function: Process input
; Input: String
;
; -----------------------------------------------------------------------------
Func ProcessInput()
	Local $name, $surname, $fnr, $sexid, $fdato
	Local $err, $input

	; Strip of white space and place into array
	$input = StringStripWS( GUICtrlRead($ctrlName), 7 )

	; Get name and surname
	$err = GetNames( $input, $name, $surname, $fnr )
	if $err > 0 then
		FlagError( $err )
		return
	EndIf

	; get all other elements from fnr
	$err = GetElements( $fnr, $fnr, $fdato, $sexid)
	if $err > 0 then
		FlagError( $err )
		return
	EndIf

	; Create pasients file
	$err = CreatePasientFile($name, $surname, $fnr, $fdato, $sexid )
	if $err > 0 then
		FlagError( $err )
		Return
	EndIf

	;MSgBox( 0, "ok", "file created" )

EndFunc


; -----------------------------------------------------------------------------
; Function: Create pasient file
; Input:
;	0 - name
;	1 - surname
; 	2 - fnr
; 	3 - fdato
;	4 - sexid (1-mann, 2-kvinne, 9-unknown)
; 	6 - namecase (0-lower, 1-upper)
; -----------------------------------------------------------------------------
Func CreatePasientFile( $name,$surname, $fnr, $fdato, $sexid )
	Local $id, $sex, $age
	Local $filetemplate
	Local $sString
	Local $fileoutput

	; Get GUID
	$id  = GetGUID()

	; Get Sex name
	$sex = GetSexName( $sexid )

	; Get age
	$age = GetAge( $fdato )
	if $age < 0 then
		return $ERR_FDATO
	endif

	; Read file
	$filetemplate = @WorkingDir & "\auto_.xml"

	$sString = FileRead($filetemplate)
	If @error = 1 Then
		FlagError($ERR_OPEN_FILE, $filetemplate & @CRLF & "with #name#, #surname#, #birthdate#, #sex#, #sexid#, #fnr#, #id#" )
		Exit
	EndIf

	$sString = StringReplace($sString, "#name#", $name)
	$sString = StringReplace($sString, "#surname#", $surname)
	$sString = StringReplace($sString, "#birthdate#", $fdato)
	$sString = StringReplace($sString, "#fnr#", $fnr)
	$sString = StringReplace($sString, "#id#", $id)
	$sString = StringReplace($sString, "#sex#", $sex)
	$sString = StringReplace($sString, "#sexid#", $sexid)

	if $fnr = 0 then
		; strip FNR
		$sString = StringRegExpReplace( $sString, "(?s)(?i)([\n\r]+<ident>\s*<id>[^/]*?</id>[^/]*?FNR.*?</ident>)", "" )
	else
		; change type
		if isDnr($fnr)  Then
			$sString = StringReplace($sString, '="FNR"', '="DNR"')
			$sString = StringReplace($sString, '="F'& ChrW(248) &'dselsnummer"', '="D-nummer"')

		EndIf
	EndIf

	; Write file
	$fileoutput = StringReplace($filetemplate, "_", "_" & $name & " " & $surname, -1)

	If isTextUpper() Then
		$fileoutput = StringReplace($filetemplate, "_", "_" & StringUpper($name & " " & $surname), -1)
	EndIf

	If FileExists($fileoutput) Then
		If FlagError( $ERR_OVERWRITE, $fileoutput, 1 ) = 2 Then
			Return
		EndIf
		FileDelete($fileoutput)
	EndIf

	Local $file = FileOpen($fileoutput, 256 + 2)

	If $file = -1 Then
		FlagError( $ERR_OPEN_FILE, $fileoutput)
		Return
	EndIf

	;Local $sString
	If FileWrite($file, $sString) = 0 Then
		FlagError( $ERR_WRITE_FILE, $fileoutput )
		Return
	EndIf

	FileClose($file)

	$sString = ""
	$sString &= "Name : " & $name & " " & $surname & @CRLF
	if $fnr <> 0 then $sString &= "Fnr  : " & $fnr & @CRLF
	$sString &= "Fdato: " & $fdato & "  (" & $sex & "-" & $age & ")" & @CRLF
	$sString &= "File : " & $fileoutput & @CRLF

	MsgBox(0, "Pasient successfully created", $sString)

EndFunc
