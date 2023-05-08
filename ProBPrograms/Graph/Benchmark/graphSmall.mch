// copyright Richard St-Denis, Universite de Sherbrooke, 2023.
MODEL graphSmall
DEFINITIONS
  "Theories/Fig9_graph.def";
SETS
  Vertex = {v1, v2, v3, v4, v5}
CONSTANTS
  G,          // A simple graph
  v0          // The initial vertex
PROPERTIES
  Graph(G) &
  G = rec(vertices: Vertex,
          edges: SymClosure({(v1,v2), (v1,v3), (v1,v4), (v1,v5), (v2,v3), (v4,v5)}) ) &
  v0 = v1 END