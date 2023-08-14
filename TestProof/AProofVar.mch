MACHINE ProveAProperty

DEFINITIONS
 //---------------------------------------------------------------------
 // ProB settings
 //---------------------------------------------------------------------
 SET_PREF_MAX_INITIALISATIONS == 1;
 SET_PREF_MAX_OPERATIONS == 1;
 SET_PREF_TIME_OUT == 1000000;
 SET_PREF_SYMBOLIC == TRUE;
//SET_PREF_SMT == TRUE;
 SET_PREF_KODKOD == FALSE;
 //---------------------------------------------------------------------
 // Import the theory
 //---------------------------------------------------------------------
 "LibraryIO.def"

OPERATIONS
  test = PRE !(x).(x : INTEGER => #(y).(y : INTEGER & y > x)) THEN
           PRINT("OK") END
END
