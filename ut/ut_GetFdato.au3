#include-once

#include "unittest.au3"


#include "..\nypasient2lib.au3"

; ==============================
; Unis tests for Function Under test
; ==============================

	; Check Alder
	; 000-499 - 1900
	; 500-749 - 1854-1899
	; 500-999 - 2000-2039
	;
	; info about fnr -
	;		https://no.wikipedia.org/wiki/F%C3%B8dselsnummer
	; sjekk fnr -
	;		http://www.fnrinfo.no/Verktoy/Kontroll.aspx
	; get checksum and generate fnr -
	;		http://www.lefdal.cc/div/mod11-sjekk.php


; fnr
UTAssertEqual( GetFdato( "10110000099" ) ,  "1900-11-10" )
UTAssertEqual( GetFdato( "31031547443" ) ,  "1915-03-31")
UTAssertEqual( GetFdato( "01016060085" ) ,  "1860-01-01" )
UTAssertEqual( GetFdato( "50089950065" ) ,  "1899-08-10" )
UTAssertEqual( GetFdato( "71019949849" ) ,  "1999-01-31" )
UTAssertEqual( GetFdato( "41019900041" ) ,  "1999-01-01" )
UTAssertEqual( GetFdato( "89230566110" ) ,  "2005-23-89" )

; nye D-serier
UTAssertEqual( GetFdato( "50084190065" ) ,  "1941-08-10" )
UTAssertEqual( GetFdato( "71019979849" ) ,  "1999-01-31" )


; short fnr
UTAssertEqual( GetFdato( "120300" ) ,  "2000-03-12" )
UTAssertEqual( GetFdato( "668815k" ) ,  "2015-88-66" )
UTAssertEqual( GetFdato( "010299M" ) ,  "1999-02-01" )
UTAssertEqual( GetFdato( "010271" ) ,  "1971-02-01" )

; long fnr
UTAssertEqual( GetFdato( "12031900" ) ,  "1900-03-12" )
UTAssertEqual( GetFdato( "12031856m" ) ,  "1856-03-12" )
UTAssertEqual( GetFdato( "12032019K" ) ,  "2019-03-12" )

; nexy year -> 2000
; this year  -> 1900
Local $nextyear  = _DateAdd( 'y', 1, _NowCalcDate())
Local $thisyear = _DateAdd( 'y', 0, _NowCalcDate())
Local $lastyear = _DateAdd( 'y', -1, _NowCalcDate())


UTAssertEqual( GetFdato( StringRegExpReplace( $nextyear, "(\d{2})(\d{2}).(\d{2}).(\d{2}).*", "$4$3$2") ) , _
						 StringRegExpReplace( $nextyear, "(\d{2})(\d{2}).(\d{2}).(\d{2}).*", "19" & "$2-$3-$4")) ; tomorrow - 1900

UTAssertEqual( GetFdato( StringRegExpReplace( $thisyear, "(\d{2})(\d{2}).(\d{2}).(\d{2}).*", "$4$3$2") ) , _
						 StringRegExpReplace( $thisyear, "(\d{2})(\d{2}).(\d{2}).(\d{2}).*", "19" & "$2-$3-$4")) ; yesterday - 1900

UTAssertEqual( GetFdato( StringRegExpReplace( $lastyear, "(\d{2})(\d{2}).(\d{2}).(\d{2}).*", "$4$3$2") ) , _
						 StringRegExpReplace( $lastyear, "(\d{2})(\d{2}).(\d{2}).(\d{2}).*", "20" & "$2-$3-$4")) ; yesterday - 2000

