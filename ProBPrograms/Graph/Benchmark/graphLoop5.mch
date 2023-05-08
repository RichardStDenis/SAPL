// copyright Richard St-Denis, Universite de Sherbrooke, 2023.
MODEL graphLoop5
DEFINITIONS
  "Theories/Fig9_graph.def";
SETS
  Vertex = {x1, x2, x3, x4, x5}
CONSTANTS
  G,          // A simple graph
  v0          // The initial vertex
PROPERTIES
  Graph(G) &
  G = rec(vertices: Vertex,
          edges: SymClosure({(x1,x2), (x2,x3), (x3,x4), (x4,x5), (x5,x1)}) ) &
  v0 = x1 END