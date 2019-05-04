#include-once

#include "unittest.au3"

#include "../nypasient2lib.au3"

; ==============================
; Unis tests for Function Under test
; ==============================


	; Check Alder
	; 000-499 - 1900
	; 500-749 - 1854-1899
	; 500-999 - 2000-2039


UTAssertEqual( GetCentury( "11110000099" ) , 19 )
UTAssertEqual( GetCentury( "11110049999" ) , 19 )
UTAssertEqual( GetCentury( "11110050099" ) , 20 )
UTAssertEqual( GetCentury( "11110089999" ) , 20 )
UTAssertEqual( GetCentury( "11110090099" ) , 20 )
UTAssertEqual( GetCentury( "11110099999" ) , 20 )
UTAssertEqual( GetCentury( "11113949999" ) , 19 )
UTAssertEqual( GetCentury( "11113950099" ) , 20 )
UTAssertEqual( GetCentury( "11113974999" ) , 20 )
UTAssertEqual( GetCentury( "11113975099" ) , 20 )
UTAssertEqual( GetCentury( "11113989999" ) , 20 )
UTAssertEqual( GetCentury( "11113990099" ) , 20 )
UTAssertEqual( GetCentury( "11113999999" ) , 20 )
UTAssertEqual( GetCentury( "11114049999" ) , 19 )
UTAssertEqual( GetCentury( "11114050099" ) , 0 )
UTAssertEqual( GetCentury( "11114089999" ) , 0 )
UTAssertEqual( GetCentury( "11114090099" ) , 19 )
UTAssertEqual( GetCentury( "11114099999" ) , 19 )
UTAssertEqual( GetCentury( "11115349999" ) , 19 )
UTAssertEqual( GetCentury( "11115350099" ) , 0 )
UTAssertEqual( GetCentury( "11115374999" ) , 0 )
UTAssertEqual( GetCentury( "11115389999" ) , 0 )
UTAssertEqual( GetCentury( "11115390099" ) , 19 )
UTAssertEqual( GetCentury( "11115399999" ) , 19 )
UTAssertEqual( GetCentury( "11115449999" ) , 19 )
UTAssertEqual( GetCentury( "11115450099" ) , 18 )
UTAssertEqual( GetCentury( "11115474999" ) , 18 )
UTAssertEqual( GetCentury( "11115475099" ) , 0 )
UTAssertEqual( GetCentury( "11115489999" ) , 0 )
UTAssertEqual( GetCentury( "11115490099" ) , 19 )
UTAssertEqual( GetCentury( "11115499999" ) , 19 )
UTAssertEqual( GetCentury( "11119900099" ) , 19 )
UTAssertEqual( GetCentury( "11119949999" ) , 19 )
UTAssertEqual( GetCentury( "11119950099" ) , 18 )
UTAssertEqual( GetCentury( "11119974999" ) , 18 )
UTAssertEqual( GetCentury( "11119975099" ) , 0 )
UTAssertEqual( GetCentury( "11119989999" ) , 0 )
UTAssertEqual( GetCentury( "11119990099" ) , 19 )
UTAssertEqual( GetCentury( "11119999999" ) , 19 )

UTAssertEqual( GetCentury( "01015474943" ) ,  18 )
UTAssertEqual( GetCentury( "01016060085" ) ,  18 )
UTAssertEqual( GetCentury( "01019950065" ) ,  18 )
UTAssertEqual( GetCentury( "01019949849" ) ,  19 )
UTAssertEqual( GetCentury( "01019900041" ) ,  19 )
UTAssertEqual( GetCentury( "01010000110" ) ,  19 )


