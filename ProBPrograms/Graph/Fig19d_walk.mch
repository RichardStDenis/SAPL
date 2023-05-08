// Generation of sets of walks (with the iterate operator).
// Author: Richard St-Denis, Universite de Sherbrooke, 2023.
MACHINE walks_iterate
SEES graphDirectedCanada /*@file "Benchmark/graphDirectedCanada.mch" */   // Machine for input data
CONSTANTS
  bound, W    // Bound on the length of walks and set of walks
ABSTRACT_CONSTANTS WalksRel
DEFINITIONS
  "LibraryIO.def";
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_MAX_INITIALISATIONS == 1;
  SET_PREF_SMT == TRUE;
  SET_PREF_SYMBOLIC == TRUE;
  SET_PREF_TIME_OUT == 100000000;

  ExtendWalks(g) == /*@symbolic*/ {w1,w2 | {w1,w2} : POW(seq(g'vertices)) &
    #(v_).((last(w1),v_) : g'edges & w2 = w1<-v_) };
  GetWalks(g, v, bnd, rel_) ==
    UNION(k_).(k_ : 1..pred(bnd) | iterate(rel_, k_) [{[v]}]);
PROPERTIES
  bound = 5 & WalksRel = ExtendWalks(G) & W = GetWalks(G, v0, bound, WalksRel)
OPERATIONS
  DisplayWalks = BEGIN PRINT(card(W)); PRINT(W) END END