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
  SET_PREF_MAX_INITIALISATIONS == 30;
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_SMT == FALSE;
  SET_PREF_SYMBOLIC == FALSE;
  SET_PREF_TIME_OUT == 10000000;

  MaximalClique_(g, c) == Clique_(g, c) &
    not (#(u_).(u_ : g'vertices - c & !(v_).(v_ : c => (u_,v_) : g'edges)));
  MaximalClique__(g, c, n) ==  MaximalClique_(g, c) & card(c) = n;
// Instance of a graph
CONSTANTS clique
PROPERTIES
  Graph(G) &
  MaximalClique__(G, clique, 2) END