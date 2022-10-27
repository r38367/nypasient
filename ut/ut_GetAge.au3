#include-once

#include "unittest.au3"
#include "../nypasient2lib.au3"

; ==============================
; Unis tests template
;
; 1. Change <include> to filename with function under test
; 2. Use function under test in Assert section
;
; ==============================


	; Check Alder
	; 000-499 - 1900
	; 500-749 - 1854-1899
	; 500-999 - 2000-2039


UTAssertEqual( GetAge( "1915-03-31") , 107)
UTAssertEqual( GetAge( "1900-11-10") , 121 )
UTAssertEqual( GetAge( "1860-01-01") ,  162 )
UTAssertEqual( GetAge( "1899-08-10") ,  123 )
UTAssertEqual( GetAge( "1999-01-31") ,  23 )
UTAssertEqual( GetAge( "1999-01-01") ,  23 )
UTAssertEqual( GetAge( "2005-23-89") ,  -1 )


