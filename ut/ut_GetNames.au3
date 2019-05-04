#include-once

#include "unittest.au3"

#include "..\nypasient2lib.au3"

; ==============================
; Unis tests for Function Under test
; ==============================


	;Return string: "Name, Surname, Birthdate(yyyy-mm-dd), Sex(1-mann,2-kvinne,9-ukejnt), Filename, Dnr(0-fnr,1-dnr)"
	Local $name, $surname, $fnr

	UTAssertEqual( GetNames( "test fnr 12086900100",$name, $surname, $fnr ), 0  ) ; simple man
	UTAssertEqual( GetNames( "test mid fnr 12086900600",$name, $surname, $fnr ), 0 ) ; simple dame
	UTAssertEqual( GetNames( "test1 mid2 mid3 sur4 12086900600",$name, $surname, $fnr ), 0 ) ; simple dame
	UTAssertEqual( GetNames( "test At3456 62086900600",$name, $surname, $fnr ), 0 ) ; simple dame
	UTAssertEqual( GetNames( "mørå VÆRRø 62086900600",$name, $surname, $fnr ), 0 ) ; simple dame

	UTAssertEqual( GetNames( "test fnr 6208690060",$name, $surname, $fnr ), 1 , "short fnr" )
	UTAssertEqual( GetNames( "test fnr 120869001001",$name, $surname, $fnr ), 1, "too long fnr" )
	UTAssertEqual( GetNames( "test 12086900100",$name, $surname, $fnr ), 1, "missed surname" )

	UTAssertEqual( GetNames( "a b 011236",$name, $surname, $fnr ), 0 )
	UTAssertEqual( GetNames( "a b 011236k",$name, $surname, $fnr ), 0 )
	UTAssertEqual( GetNames( "a b 011236M",$name, $surname, $fnr ), 0 )
	UTAssertEqual( GetNames( "a b 210800m",$name, $surname, $fnr ), 0 )

	UTAssertEqual( GetNames( "12086900100 test fnr name3",$name, $surname, $fnr ), 0  ) ; simple man
	UTAssertEqual( GetNames( "12081999 test fnr",$name, $surname, $fnr ), 0  ) ; simple man
	UTAssertEqual( GetNames( "12081999m test fnr",$name, $surname, $fnr ), 0  ) ; simple man
	UTAssertEqual( GetNames( "120869K test fnr",$name, $surname, $fnr ), 0  ) ; simple man



