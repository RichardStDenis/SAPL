// copyright Richard St-Denis, Universite de Sherbrooke, 2023.
MODEL graphCanada

SETS
  Vertex = {AB, BC, MB, NB, NL, NS, NT, NU, ON, PE, QC, SK, YT}

DEFINITIONS
  "Theories/Fig9_graph.def";

CONSTANTS
  G,          // A graph
  v0          // The initial vertex

PROPERTIES
//  Graph(G) &
  G = rec(vertices: Vertex,
          edges: SymClosure({(AB, BC), (AB, NT), (AB, SK),
                   (BC, NT), (BC, YT),
                   (MB, NT), (MB, NU), (MB, ON), (MB, SK),
                   (NB, NS), (NB, PE), (NB, QC),
                   (NL, NS), (NL, NU), (NL, PE), (NL, QC),
                   (NS, PE),
                   (NT, NU), (NT, SK), (NT, YT),
                   (NU, QC), (NU, SK),
                   (ON, QC),
                   (PE, QC) }) ) &
  v0 = NS
END