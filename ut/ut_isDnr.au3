#include-once

#include "unittest.au3"
#include "..\nypasient2lib.au3"

; ==============================
; Unis tests for Function Under test
; ==============================


UTAssertTrue( isDnr( "42020199999" ) )
UTAssertTrue( isDnr( "50020199999" ) )
UTAssertTrue( isDnr( "62020199999" ) )
UTAssertTrue( isDnr( "71020199999" ) )
UTAssertFalse( isDnr( "21020199999" )  )
UTAssertFalse( isDnr( "01020199999" )  )
UTAssertFalse( isDnr( "91020199999" )  )

