// Generation of a set of paths (definition by comprehension).
// Author: Richard St-Denis, Universite de Sherbrooke, 2023.
MACHINE paths_comprehension
SEES graphDirectedCanada /*@file "graphDirectedCanada.mch" */   // Machine for input data
CONSTANTS
  bound, P       // Bound on the length of paths and set of paths
DEFINITIONS
  "LibraryIO.def";
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_MAX_INITIALISATIONS == 1;
  SET_PREF_SMT == FALSE;
  SET_PREF_SYMBOLIC == TRUE;
  SET_PREF_TIME_OUT == 100000000;

  GetPaths(g, v, bnd) ==
    UNION(i_).(i_ : 2..bnd | {seq_ |
      seq_ : seq(g'vertices) & size(seq_) = i_ & seq_(1) = v &
      (!(k_).(k_ : 1..pred(i_) => (seq_(k_),seq_(succ(k_))) : g'edges)) &
      !(k_).(k_ : 1..i_ =>
        not(#(j_).(j_ : 1..pred(i_) & j_ /= k_ & seq_(j_) = seq_(k_))) ) });
PROPERTIES
  bound = 5 & P = GetPaths(G, v0, bound)
OPERATIONS
  DisplayPaths = BEGIN PRINT(card(P)); PRINT(P) END END