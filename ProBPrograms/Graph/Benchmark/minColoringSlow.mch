// Minimum coloring problem (first version).
// Richard St-Denis, Universite de Sherbrooke, 2023.

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
  Colored_(g, f) == !(v_).(v_ : g'vertices =>
                           f(v_) /: UNION(u_).(u_ : Adjacent(g, v_) | {f(u_)}) );
  MinumumColoring(g, f, C) == Coloring(f, g'vertices, C) & Colored_(g, f) &
    not (#(f_).(Coloring(f_, g'vertices, C) & Colored_(g, f_) & ran(f_) <<: ran(f)))

SETS
  Color = {blue, brown, gray, green, pink, red}  // Set of admissible colors

CONSTANTS
  phi   // A coloring

PROPERTIES
  Coloring(phi, G'vertices, Color) &
  MinumumColoring(G, phi, Color)

OPERATIONS
  DisplayColoring = PRE Graph(G) THEN
    PRINT(card(ran(phi))); PRINT("The coloring: "); PRINT(phi) END END