// Minimum coloring problem (step-by-step).
// Richard St-Denis, Universite de Sherbrooke, 2023.

MACHINE Minumum_Coloring

SEES //graphCanada /*@file "graphCanada.mch" */   // Machine for input data
     //graphDurer /*@file "graphDurer.mch" */
     //graphLoop5 /*@file "graphLoop5.mch" */
     graphLoop27 /*@file "graphLoop27.mch" */
     //graphSmall /*@file "graphSmall.mch" */
     //graphUSA /*@file "graphUSA.mch" */

DEFINITIONS
  "LibraryIo.def";
  "Theories/Fig9_graph.def";
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_MAX_INITIALISATIONS == 1;
  SET_PREF_SMT == FALSE;
  SET_PREF_SYMBOLIC == FALSE;
  SET_PREF_TIME_OUT == 100000000;

  Coloring(f, DOM, RAN) == f : DOM --> RAN;      // Total coloring function
  Colored(g, f) == !(v_).(v_ : g'vertices => f(v_) /: f[Adjacent(g, v_)]);

SETS
  Color = {blue, brown, gray, green, pink, red}  // Set of admissible colors

VARIABLES C

INITIALISATION C := Color

INVARIANT C <: Color

OPERATIONS
  get_coloring = PRE Graph(G) THEN
    ANY phi, c WHERE
      c : ran(phi) &
      Coloring(phi, G'vertices, C) & Colored(G, phi) THEN
      PRINT("The colors: "); PRINT(C);
      PRINT(card(ran(phi))); PRINT("The coloring; "); PRINT(phi);
      C := ran(phi)-{c} END END END