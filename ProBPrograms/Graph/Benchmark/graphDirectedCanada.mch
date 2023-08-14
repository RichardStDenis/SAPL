// copyright Richard St-Denis, Universite de Sherbrooke, 2023.
MODEL graphDirectedCanada

SETS
  Vertex = {AB, BC, MB, NB, NL, NS, NT, NU, ON, PE, QC, SK, YT}

DEFINITIONS
  "Theories/Fig9_graph.def";

CONSTANTS
  G,          // A graph
  v0          // The initial vertex

PROPERTIES
  G = rec(vertices: Vertex,
          edges: {(SK, AB), (AB, BC), (BC, YT), (YT, NT), (NT, NU), (NU, MB), 
                  (NT, AB), (NT, SK),
                  (SK, MB), (MB, ON), (ON, QC),
                  (QC, NL), (QC, NB), (NB, NS), (NB, PE) } ) &
  v0 = SK
END