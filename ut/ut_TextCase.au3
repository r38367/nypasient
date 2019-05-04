#include "unittest.au3"
#include "../nypasient2lib.au3"

SetTextUpper()
UTAssertTrue( isTextUpper() )

SetTextProper()
UTAssertFalse( isTextUpper() )
