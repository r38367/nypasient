#include-once

#include <Array.au3>

OnAutoItExitRegister("FlushTestResults")


#cs ----------------------------------------------------------------------------

 Micro unit test framework


#ce ----------------------------------------------------------------------------

Global $iTestCount = 0
Global $iTotalAssertions =0
Global $iTotalPass = 0
Global $iTotalFail = 0
Global $aResults[1]
Global $TimeEnd
Global $iTimeBegin = TimerInit()
Global $bUseSetup = false
Global $sCurrentTestName = ""

Func Test( $testName = @ScriptName )
	; Reset Global Variables
	$iTestCount += 1

	If $iTestCount > 1 Then
		;Call ("TestTearDown" )
	EndIf

	$sCurrentTestName = $testName
;dbg( $iTestCount & ";" & $testName )

	;Call( "TestSetup" )
EndFunc


Func UTAssertTrue(Const $bool, Const $msg = "Assert Failure", Const $erl = @ScriptLineNumber)
    $iTotalAssertions += 1
	If NOT $bool Then
        DoTestFail($msg, $erl)
    Else
		DoTestPass()
	EndIf

EndFunc

Func UTAssertFalse(Const $bool, Const $msg = "Assert Failure", Const $erl = @ScriptLineNumber)
    Return UTAssertTrue( not $bool, $msg, $erl )
EndFunc

Func UTAssertEqual(Const $a, Const $b, Const $msg = "Assert Failure", Const $erl = @ScriptLineNumber)
   	$iTotalAssertions += 1
	If $a == $b Then
		DoTestPass()
	Else
		DoTestFail( StringFormat( $msg & " ( was=[%s], expected=[%s] )", $a, $b ), $erl)
	EndIf

EndFunc

Func DoTestPass()
	$iTotalPass += 1
	;ConsoleWrite( "." )
EndFunc

Func DoTestFail( $msg, $erl )
	$iTotalFail += 1
	Local $message = @ScriptName & " [" & $sCurrentTestName & "] (" & $erl & ") := " & $msg & @LF
	;StringFormat( "%-15s %s", $iTotalAssertions, "Error in " & $sCurrentTestName & " -> " & $msg  )
	_ArrayAdd( $aResults, $message )
	ConsoleWrite( $message )
EndFunc


Func FlushTestResults()
	;Call ("TestTearDown" )

	ConsoleWrite( StringFormat( "Tests:%d, Total:%d, Pass:%d, Fail:%d ", _
		$iTestCount, $iTotalAssertions, $iTotalPass, $iTotalFail ) & @CRLF)

	;$TimeEnd = Round(TimerDiff($iTimeBegin)/1000 , 3)
	;ConsoleWrite( "Total Time: " & $TimeEnd & " seconds" & @CRLF )

EndFunc

Func dbg(Const $msg )
	if @Compiled then
		MsgBox( 0, "Debug", $msg )
	Else
		ConsoleWrite( $msg & @LF)
	EndIf
	return 0
EndFunc   ;==>dbg

Func err(Const $msg, Const $error = @error, Const $extended = @extended, Const $erl = @ScriptLineNumber)
	ConsoleWrite("(" & $erl & ") : = (" & $error & ")(" & $extended & ") " & $msg & @LF)

	If $error <> 0 Then SetError($error, $extended, $error)

	Return $error
EndFunc   ;==>err


