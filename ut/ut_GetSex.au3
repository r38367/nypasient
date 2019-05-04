#include-once


#include "unittest.au3"

; ==============================
; Unis tests template
;
; 1. Change <include> to filename with function under test
; 2. Use function under test in Assert section
;
; ==============================


#include "..\nypasient2lib.au3"

; ==============================
; Unis tests for Function Under test
; ==============================


UTAssertEqual( GetSexName( 1 ) , "Mann" )
UTAssertEqual( GetSexName( 2 ) , "Kvinne" )
UTAssertEqual( GetSexName( 0 ) , "Ukjent" )
UTAssertEqual( GetSexName( 9 ) , "Ukjent" )

UTAssertEqual( GetSexId( "M" ) , 1 )
UTAssertEqual( GetSexId( "m" ) , 1 )
UTAssertEqual( GetSexId( "K" ) , 2 )
UTAssertEqual( GetSexId( "k" ) , 2 )
UTAssertEqual( GetSexId( "x" ) , 9 )
UTAssertEqual( GetSexId( 3 ) , 9 )

