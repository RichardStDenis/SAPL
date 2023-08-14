// Proper vertex coloring problem (without I/O and with a deferred and partially enumerated set of colors).
// Richard St-Denis, Universite de Sherbrooke, 2023.

MACHINE Proper_Vertex_Coloring
// Extension of the graph theory
DEFINITIONS
  "LibraryIo.def";
  "Theories/Fig9_graph.def";
  SET_PREF_MAX_OPERATIONS == 1;
  SET_PREF_TIME_OUT == 500000;

  Coloring(f, DOM, RAN) == f : DOM --> RAN;   // Total coloring function
  Colored(g, f) == !(v_).(v_ : g'vertices => f(v_) /: f[Adjacent(g, v_)]);
  Colored_(g, f) == !(v_).(v_ : g'vertices =>
                           f(v_) /: UNION(u_).(u_ : Adjacent(g, v_) | {f(u_)}) );
  MinimumColoring(g, f, C) == Coloring(f, g'vertices, C) & Colored(g, f) &
    not (#(f_).(Coloring(f_, g'vertices, C) & Colored(g, f_) & ran(f_) <<: ran(f)))
// Instance of the proper vertex coloring problem
SETS
  Color;                                      // Set of admissible colors
  Vertex = {v1, v2, v3, v4, v5}
CONSTANTS green, red, G
PROPERTIES
  card(Color) = 6 & green : Color & red : Color & green /= red &
  Graph(G) &
  G = rec(vertices: Vertex,
          edges: SymClosure({(v1,v2), (v1,v3), (v1,v4), (v1,v5), (v2,v3), (v4,v5)}) )
OPERATIONS
  // Operation for checking if the graph is undirected
  c__undirected = PRE not(Undirected(G)) THEN skip END;
  // Operation for solving the proper vertex coloring problem 
  r__colored = ANY phi WHERE Coloring(phi, G'vertices, Color) & Colored(G, phi) THEN
                 PRINT("The coloring: "); PRINT(phi) END END