// Generation of a set of walks (definition by comprehension).
// Author: Richard St-Denis, Universite de Sherbrooke, 2023.
MACHINE walks_comprehension
SEES graphDirectedCanada /*@file "Benchmark/graphDirectedCanada.mch" */   // Machine for input data
CONSTANTS
  bound, W       // Bound on the length of walks and set of walks
DEFINITIONS
  "LibraryIO.def";
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_MAX_INITIALISATIONS == 1;
  SET_PREF_SMT == FALSE;
  SET_PREF_SYMBOLIC == FALSE;
  SET_PREF_TIME_OUT == 100000000;

  GetWalks(g, v, bnd) ==
    UNION(i_).(i_ : 2..bnd | {seq_ |
      seq_ : seq(g'vertices) & size(seq_) = i_ & seq_(1) = v &
      !(k_).(k_ : 1..pred(i_) => (seq_(k_),seq_(succ(k_))) : g'edges) });
PROPERTIES
  bound = 5 & W = GetWalks(G, v0, bound)
OPERATIONS
  DisplayWalks = BEGIN PRINT(card(W)); PRINT(W) END END