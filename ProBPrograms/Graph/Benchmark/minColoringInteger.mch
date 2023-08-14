// Minimum coloring problem (fourth version).
// A referee, Universite de Sherbrooke, 2023.

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
  scope_Color == 6;

  // Extension of the graph theory
  Color == 1..scope_Color;
  CurrentColors == 1..NrColors;

  Coloring(f, DOM, RAN) == f : DOM --> RAN;   // Total coloring function
  Colored(g, f) == !(v_).(v_ : g'vertices => f(v_) /: f[Adjacent(g, v_)]); 
  NoBetterColoringExists(g, n) ==
    not (#(f_).(Coloring(f_, g'vertices, 1..(n-1)) & Colored(g, f_)));

CONSTANTS
  NrColors, phi

PROPERTIES
  NrColors : 0..scope_Color &
  Coloring(phi, G'vertices, CurrentColors) &
  Colored(G, phi) &
  NoBetterColoringExists(G, NrColors)

OPERATIONS
  DisplayColoring = PRE Graph(G) THEN
    PRINT(card(ran(phi))); PRINT("The coloring: "); PRINT(phi) END END