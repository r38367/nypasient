#include-once

#include "unittest.au3"
#include "../nypasient2lib.au3"

; ==============================
; Unis tests for Function Under test
; ==============================


; names
UTAssertEqual( StringProper( "anna" ) , "Anna" )
UTAssertEqual( StringProper( "jon-sindre" ) , "Jon-Sindre" )
UTAssertEqual( StringProper( "JON-SINDRE" ) , "Jon-Sindre" )

; norske
UTAssertEqual( StringProper( "ANØA" ) , "Anøa" )
UTAssertEqual( StringProper( "øNNå" ) , "Ønnå" )
UTAssertEqual( StringProper( "øæåØÆÅ" ) , "Øæåøæå" )
UTAssertEqual( StringProper( "KÅ-ØÆR" ) , "Kå-Øær" )

; numbers
UTAssertEqual( StringProper( "ADD567" ) , "Add567" )
UTAssertEqual( StringProper( "add567" ) , "Add567" )
UTAssertEqual( StringProper( "ADD567-DEF3" ) , "Add567-Def3" )
UTAssertEqual( StringProper( "a2-3FF" ) , "A2-3ff" )
UTAssertEqual( StringProper( "A4B-FD57-123" ) , "A4b-Fd57-123" )
UTAssertEqual( StringProper( "543 5A2F-3AB" ) , "543 5a2f-3ab" )
UTAssertEqual( StringProper( "AE657382F-3 AB-CD" ) , "Ae657382f-3 Ab-Cd" )
UTAssertEqual( StringProper( "Ae657382F-3" ) , "Ae657382f-3" )
