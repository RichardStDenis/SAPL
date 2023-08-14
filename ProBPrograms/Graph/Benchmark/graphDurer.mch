// copyright Richard St-Denis, Universite de Sherbrooke, 2023.
MODEL graphDurer
DEFINITIONS
  "Theories/Fig9_graph.def";
SETS
  Vertex = {x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12}
CONSTANTS
  G,          // The Durer graph
  v0          // The initial vertex
PROPERTIES
  Graph(G) &
  G = rec(vertices: Vertex,
          edges: SymClosure({(x1, x2), (x2, x3),  (x3, x4), (x4, x5),  (x5, x6), (x6, x1),
                             (x1, x7), (x2, x10), (x3, x9), (x4, x12), (x5, x8), (x6, x11),
                             (x7, x8), (x8, x9),  (x9, x7), 
                             (x10, x11), (x11, x12), (x12, x10) }) ) &
  v0 = x1 END