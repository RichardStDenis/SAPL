// Precoloring extension problem (with I/O and data consistency).
// Richard St-Denis, Universite de Sherbrooke, 2022

MACHINE Precoloring

DEFINITIONS
  SET_PREF_MAX_INITIALISATIONS == 1;
  SET_PREF_MAX_OPERATIONS == 1;

  "LibraryIo.def";
  "LibraryStrings.def";
  "LibraryXML.def";
  "Theories/Fig9_graph.def";

  graphfilename == "graph.xml";
  coloringfilename == "coloring.xml";
  // Extension of the graph theory
  Coloring(f, DOM, RAN) == f : DOM --> RAN;   // Total coloring function
  Colored(g, f) == !(v_).(v_ : g'vertices => f(v_) /: f[Adjacent(g, v_)]);

VARIABLES C, G

INITIALISATION C := rec(colors: {}, pi: {}); G := rec(vertices: {}, edges: {})

INVARIANT C : struct(colors: POW(STRING), pi: STRING <-> STRING) &
          G : struct(vertices: POW(STRING), edges: STRING <-> STRING)

OPERATIONS
  get_graph = PRE G'vertices = {} THEN
    VAR xml, strs, i, v, str_str, e IN
      xml := READ_XML(graphfilename, "ISO-8859-1");
      strs := STRING_SPLIT(xml(2)'attributes("vertices"), ",");
      i := 1; v := {};
      WHILE i <= card(strs) DO
        v := v \/ {strs(i)}; i:= i + 1
      INVARIANT i : 1..card(strs)+1
      VARIANT card(strs)-i END;

      strs := STRING_SPLIT(xml(3)'attributes("edges"), ";");
      i := 1; e := {};
      WHILE i <= card(strs) DO
        str_str := STRING_SPLIT(strs(i), ",");
        e := e \/ {str_str(1)|->str_str(2)}; i:= i + 1
      INVARIANT i : 1..card(strs)+1
      VARIANT card(strs)-i END;
      G := rec(vertices: v, edges: SymClosure(e)) END END;

  get_partial_coloring = PRE C'colors = {} THEN
    VAR xml, strs, i, c, str_str, p IN
      xml := READ_XML(coloringfilename, "ISO-8859-1");
      strs := STRING_SPLIT(xml(2)'attributes("colors"), ",");
      i := 1;   c := {};
      WHILE i <= card(strs) DO
        c := c \/ {strs(i)}; i:= i + 1
      INVARIANT i : 1..card(strs)+1
      VARIANT card(strs)-i END;

      strs := STRING_SPLIT(xml(3)'attributes("partialColoring"), ";");
      i := 1;   p := {};
      WHILE i <= card(strs) DO
        str_str := STRING_SPLIT(strs(i), ",");
        p := p \/ {str_str(1)|->str_str(2)}; i:= i + 1
      INVARIANT i : 1..card(strs)+1
      VARIANT card(strs)-i END;
      C := rec(colors: c, pi: p) END END;

  get_coloring = PRE G'vertices /= {} &
                     // Rules for data consistency 
                     Graph(G) & dom(C'pi) <: G'vertices & ran(C'pi) <: C'colors THEN
    ANY phi WHERE
      Coloring(phi, G'vertices, C'colors) & Colored(G, phi) & C'pi <: phi THEN
      PRINT("The coloring; "); PRINT(phi) END END END