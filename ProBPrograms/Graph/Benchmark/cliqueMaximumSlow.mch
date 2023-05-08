MACHINE testGraphTheory
// Graph theory (macro definitions)
SEES //graphCanada /*@file "graphCanada.mch" */   // Machine for input data
     //graphDurer /*@file "graphDurer.mch" */
     graphLoop5 /*@file "graphLoop5.mch" */
     //graphLoop27 /*@file "graphLoop27.mch" */
     //graphSmall /*@file "graphSmall.mch" */
     //graphUSA /*@file "graphUSA.mch" */
DEFINITIONS
  "LibraryIo.def";
  "Theories/Fig9_graph.def";
  SET_PREF_MAX_INITIALISATIONS == 2;
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_SMT == FALSE;
  SET_PREF_SYMBOLIC == FALSE;
  SET_PREF_TIME_OUT == 10000000;

  MaximalClique_(g, c) == Clique_(g, c) &
    not (#(u_).(u_ : g'vertices - c & !(v_).(v_ : c => (u_,v_) : g'edges)));
  MaximumClique_(g, c) == MaximalClique_(g, c) &
    not (#(c_).(MaximalClique_(g, c_) & card(c) < card(c_)));
CONSTANTS clique
PROPERTIES
  Graph(G) &
  MaximumClique_(G, clique) END