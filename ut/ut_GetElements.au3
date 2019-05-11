#include-once

#include "unittest.au3"
#include "../nypasient2lib.au3"

; ==============================
; Unis tests for Function Under test
; ==============================



Local $fnr, $fdato, $sexid

; full fnr
UTAssertEqual( GetElements( "12086900100" , $fnr, $fdato, $sexid ), 0 )
		UTAssertEqual( $fnr, "12086900100" )
		UTAssertEqual( $fdato, "1969-08-12" )
		UTAssertEqual( $sexid, 1 )

UTAssertEqual( GetElements( "12086900600" , $fnr, $fdato, $sexid ), 0 )
		UTAssertEqual( $fnr, "12086900600" )
		UTAssertEqual( $fdato, "1969-08-12" )
		UTAssertEqual( $sexid, 2 )

; full dnr
UTAssertEqual( GetElements( "52086900100" , $fnr, $fdato, $sexid ), 0 )
		UTAssertEqual( $fnr, "52086900100" )
		UTAssertEqual( $fdato, "1969-08-12" )
		UTAssertEqual( $sexid, 1 )

; Error : dd in fnr
UTAssertEqual( GetElements( "35010199999" , $fnr, $fdato, $sexid ), 2 )
; Error : mm in fnr
UTAssertEqual( GetElements( "11210199999" , $fnr, $fdato, $sexid ), 2 )
; Error : dd in Dnr
UTAssertEqual( GetElements( "82010199999" , $fnr, $fdato, $sexid ), 2 )
		;

; short fdato
UTAssertEqual( GetElements( "120869" ,$fnr, $fdato, $sexid ), 0 )
		UTAssertEqual( $fnr, "0" )
		UTAssertEqual( $fdato, "1969-08-12" )
		UTAssertEqual( $sexid, 9 )

; short fdato
UTAssertEqual( GetElements( "120819" ,$fnr, $fdato, $sexid ), 0 )
		UTAssertEqual( $fnr, 0 )
		UTAssertEqual( $fdato, "1919-08-12" )
		UTAssertEqual( $sexid, 9 )

UTAssertEqual( GetElements( "120869k" ,$fnr, $fdato, $sexid ), 0 )
		UTAssertEqual( $fnr, 0 )
		UTAssertEqual( $fdato, "1969-08-12" )
		UTAssertEqual( $sexid, 2 )

UTAssertEqual( GetElements( "110869M" ,$fnr, $fdato, $sexid ), 0 )
		UTAssertEqual( $fnr, 0 )
		UTAssertEqual( $fdato, "1969-08-11" )
		UTAssertEqual( $sexid, 1)

; long fdato
UTAssertEqual( GetElements( "12082008K" ,$fnr, $fdato, $sexid ), 0 )
		UTAssertEqual( $fnr, 0 )
		UTAssertEqual( $fdato, "2008-08-12" )
		UTAssertEqual( $sexid, 2 )

UTAssertEqual( GetElements( "12071856" ,$fnr, $fdato, $sexid ), 0 )
		UTAssertEqual( $fnr, 0 )
		UTAssertEqual( $fdato, "1856-07-12" )
		UTAssertEqual( $sexid, 9 )


