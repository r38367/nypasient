#include "systemtest.au3"
#include "../nypasient2lib.au3"

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Functions to perform system test.

#ce ----------------------------------------------------------------------------

Func TestSetup()
	StartApp()
EndFunc

Func TestTearDown()
	CloseApp()
EndFunc

#cs ++++++++++++

#ce ++++++++++++


Test( "open app")
	UTAssertTrue( StartApp(), "start app" )
	Sleep(100)
	UTAssertTrue( CloseApp(), "close app" )

Test( "Error 1: fail format - fnr" )
	StartApp()
	Sleep(100)
		UTAssertTrue( SendInput("anna vann 01020") )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Error 1") )

	Sleep(100)
	CloseApp()


Test( "Error 1: fail format - name" )
	StartApp()
	Sleep(100)
		UTAssertTrue( SendInput("vann 12121299999") )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Error 1") )
		Sleep(100)

	CloseApp()

Test( "Error 2: fail fnr" )
	StartApp()
	Sleep(100)
		UTAssertTrue( SendInput("a b 81010199999") )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Error 2") )
		Sleep(100)

	CloseApp()

Test( "Error 3: fail age/fdato" )
	StartApp()
	Sleep(100)
		UTAssertTrue( SendInput("a b 30027799999") )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Error 3") )
		Sleep(100)

	CloseApp()

Test( "Error 5: no auto_.xml" )
	StartApp()
	Sleep(100)
	Local $filetemplate = @WorkingDir & "\auto_.xml"
		if FileExists( $filetemplate ) then
			FileMove( $filetemplate, $filetemplate &".renamed" )
		EndIf
		UTAssertTrue( SendInput("a b 01020399999") )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Error 5") )
		Sleep(100)
		if FileExists( $filetemplate &".renamed" ) then
			FileMove( $filetemplate &".renamed",$filetemplate )
		EndIf


	CloseApp()


Test( "create FNR")
	VerifyInput( "Anna Fnr Vanna", "01020399999" )

Test( "create DNR")
	VerifyInput( "Anna Dnr Vanna", "51020399999" )

Test( "create FDATO 2000")
	VerifyInput( "Anna Fdato 2000", "12012008" )

Test( "create FDATO 1900")
	VerifyInput( "Anna Fdato 1900", "12011908" )

Test( "create FDATO MAN")
	VerifyInput( "Anna Fdato Mann", "12011945m" )

Test( "create FDATO KVINNE")
	VerifyInput( "Anna Fdato Kvinne", "12012018K" )

Test( "create UPPERCASE")
StartApp()
	Sleep(100)
	Local $tmp_name = "THIS UPPER"
		UTAssertTrue( SendInput(  $tmp_name & " 12012008K") )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Pasient successfully") )
		Sleep(100)

	FileDelete( @WorkingDir & "\auto_" & $tmp_name & ".xml" )

	CloseApp()

Test( "create PROPER")

StartApp()
	Sleep(100)
	Local $tmp_name = "THIS PROPER"
		UTAssertTrue( SendInput(  $tmp_name & " 12012008K") )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Pasient successfully") )
		Sleep(100)

	FileDelete( @WorkingDir & "\auto_" & $tmp_name & ".xml" )

	CloseApp()


Test( "Error 8: overwrite - no" )
	StartApp()
	Sleep(100)
	Local $filetemplate = @WorkingDir & "\auto_.xml"
	Local $f = StringReplace( $filetemplate, "_.xml", "_Overwright NO.xml" )

		FileCopy( $filetemplate, $f )
		UTAssertTrue( SendInput("overwright no 01020399999") )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Error 8") )
		Sleep(100)
		FileDelete( $f )

	CloseApp()

Test( "Error 8: overwrite - yes" )
	StartApp()
	Sleep(100)
	Local $filetemplate = @WorkingDir & "\auto_.xml"
	Local $f = StringReplace( $filetemplate, "_.xml", "_Overwright YES.xml" )
		;ConsoleWrite( $f & @CRLF )
		FileCopy( $filetemplate, $f )
		UTAssertTrue( SendInput("overwright YES 01020399999") )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Error 8") )
		Sleep(100)
		; select Ok
		CloseErrorBox( "Button1" )
		Sleep(100)
		UTAssertTrue( GetErrorBox("Pasient successfully") )
		CloseErrorBox()
		Sleep(100)

		FileDelete( $f )

	CloseApp()


Test( "File name in Upper case " )

Test( "File name in proper case " )
	;StartApp()
	;CloseApp()
	;UTAssertTrue( false )

Func VerifyInput( const $name, const $fnr )

	Local $file = "\auto_" & $name & ".xml"

	StartApp()
	Sleep(100)

	UTAssertTrue( SendInput(  $name & " " & $fnr ) )
	Sleep(100)
	UTAssertTrue( GetErrorBox("Pasient successfully") )
	Sleep(100)
	UTAssertFileEqual( @WorkingDir & $file, @WorkingDir & "\..\files" & $file )
	FileDelete( @WorkingDir & $file )
	CloseApp()
EndFunc

