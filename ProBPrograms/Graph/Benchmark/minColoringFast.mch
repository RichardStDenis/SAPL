// Minimum coloring problem (third version).
// A referee, Universite de Sherbrooke, 2023.

MACHINE Minumum_Coloring

SEES //graphCanada /*@file "graphCanada.mch" */   // Machine for input data
     //graphDurer /*@file "graphDurer.mch" */
     graphLoop5 /*@file "graphLoop5.mch" */
     //graphLoop27 /*@file "graphLoop27.mch" */
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
  Coloring(f, DOM, RAN) == f : DOM --> RAN;      // Total coloring function
  Colored(g, f) == !(v_).(v_ : g'vertices => f(v_) /: f[Adjacent(g, v_)]);
  MinimumColoring(g, f, C) == Coloring(f, g'vertices, C) & Colored(g, f) &
    not (#(f_).(Coloring(f_, g'vertices, C) & Colored(g, f_) & ran(f_) <<: ran(f)))

SETS
  Color = {blue, brown, gray, green, pink, red}  // Set of admissible colors

CONSTANTS
  phi   // A coloring

PROPERTIES
  Coloring(phi, G'vertices, Color) &
  MinimumColoring(G, phi, Color)

OPERATIONS
  DisplayColoring = PRE Graph(G) THEN
    PRINT(card(G'vertices)); PRINT(card(G'edges));
    PRINT(card(ran(phi))); PRINT("The coloring: "); PRINT(phi) END END