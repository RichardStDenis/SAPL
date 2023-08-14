// Sorting
// Richard St-Denis, Universite de Sherbrooke, 2022
MACHINE Sorting

DEFINITIONS
  SET_PREF_MAX_INITIALISATIONS == 1;
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_MAXINT == 511;
  SET_PREF_MININT == 0;
  SET_PREF_TIME_OUT == 100000000;

  "LibraryIo.def";
  "LibraryStrings.def";
  "Theories/sorting.def";
  filename == "sortdata20.txt"

CONSTANTS Values
PROPERTIES Values = MININT..MAXINT

VARIABLES A
INITIALISATION A := {}
INVARIANT A : IntArray(MAXINT, Values)

OPERATIONS
  get_input_data =
    VAR i, instance, instances IN
      instances := READ_FILE_AS_STRINGS(filename);
      instance := STRING_SPLIT(instances(1), ",");
      i := 1;
      WHILE i <= card(instance) DO
        A(i) := STRING_TO_INT(instance(i));   i := i + 1
      INVARIANT i : 1..card(instance) \/ {card(instance)+1}
      VARIANT card(instance)-i END END;

  run_sort =
    ANY sortA, sortedA WHERE
        sort(A, sortA, sortedA)
    THEN PRINT("Sorted array:"); PRINT(sortedA) ; PRINT(A); PRINT(sortA) END
/*
  run_stableSort =
    ANY sortA, sortedA WHERE
        sortStably(A, sortA, sortedA)
    THEN PRINT("Sorted (stably) array:"); PRINT(sortedA) ; PRINT(A); PRINT(sortA) END;
  run_idempotent_ =
    ANY sortA, sortedA, sort2A WHERE
      sort(A, sortA, sortedA)
        THEN PRINT("Array sorted (sort):"); PRINT(sortedA);
             IF idempotent_(A, sortedA, sort2A) THEN PRINT("Idempotent") END END;

  check_idempotent =
    ANY sortA, sortedA, sort2A, sorted2A WHERE
      not (idempotent(A, sortedA, sorted2A, sortA, sort2A))
    THEN PRINT("Counterexample:"); PRINT(A); PRINT(sortA) END;

  run_immutable =
    ANY sortA, sortedA, sortB, sortedB WHERE
      sort(A, sortA, sortedA)
    THEN PRINT("Permutation (sort):"); PRINT(sortB);
         IF immutable(sortedA, sortB, sortedB) THEN PRINT("Immutable") END END;

  check_immutable =
    ANY sortA, sortedA, sortB, sortedB WHERE
        sort(A, sortA, sortedA) & not (immutable(sortedA, sortB, sortedB))
    THEN PRINT("Counterexample:"); PRINT(sortedB); PRINT(sortB) END
*/END