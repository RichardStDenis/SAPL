// Generation of sets of walks (with the lambda operator).
// Author: Richard St-Denis, Universite de Sherbrooke, 2023.
MACHINE walks_lambda
SEES graphDirectedCanada /*@file "Benchmark/graphDirectedCanada.mch" */   // Machine for input data
CONSTANTS
  bound, W    // Bound on the length of walks and set of walks
ABSTRACT_CONSTANTS GetWalksFun
DEFINITIONS
  "LibraryIO.def";
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_MAX_INITIALISATIONS == 1;
  SET_PREF_SMT == TRUE;
  SET_PREF_SYMBOLIC == TRUE;
  SET_PREF_TIME_OUT == 100000000;

  baseCase(g, v) == UNION(v_).(v_ : g'edges[{v}] | {[v,v_]});
  inductionRule(g, S) == S \/ {w2 |
    #(w1, v_).(w1 : S & (last(w1),v_) : g'edges & w2 = w1<-v_) };
  GetWalks(g, bnd, fun_) == /*@symbolic*/ %(Si).(Si : POW(seq(g'vertices)) |
    LET S BE S = inductionRule(g, Si) IN
      IF #(w_).(w_ : S & size(w_) >= bnd) THEN S ELSE fun_(S) END END )
PROPERTIES
  bound = 5 & GetWalksFun = GetWalks(G, bound, GetWalksFun) &
  W = GetWalksFun(baseCase(G, v0))
OPERATIONS
  DisplayWalks = BEGIN PRINT(card(W)); PRINT(W) END END