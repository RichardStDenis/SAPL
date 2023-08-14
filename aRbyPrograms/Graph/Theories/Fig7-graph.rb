# A basic graph theory.
# Author: Richard St-Denis, Universite de Sherbrooke, 2022.
alloy :GraphTheory do
  abstract sig Vertex [] {}
  abstract sig Graph [
    vertices: (set Vertex),
    edges: (set Vertex ** Vertex) ] {
      (edges.(Vertex) + Vertex.(this.edges)).in? vertices and
      (edges & iden).size == 0 and edges == ~edges }

  fun adjacent[g: (one Graph), v: (one Vertex)] [(set Vertex)] {v.(g.edges)}
  fun degree[g: (one Graph), v: (one Vertex)] [(one Int)] {(adjacent[g, v]).size}
  fun sym_closure[e: (set Vertex ** Vertex)] [(set Vertex ** Vertex)] {e + ~e}

  pred clique[g: (one Graph), c: (set Vertex)] {
    c.in? g.vertices and
    all(u: c) {all(v: c-u) {(u**v).in? g.edges}} }
  pred maximal_clique[g: (one Graph), c: (set Vertex)] {
    clique[g,c] and
    no(u: g.vertices-c) {all(v: c) {(u**v).in? g.edges}} }
  pred complete[g: (one Graph)] {
    all(v: g.vertices) {degree[g, v] == (g.vertices).size - 1} }
  pred undirected[g: (one Graph)] {
    no(v: g.vertices) {v.in? v.(g.edges)} and
    all(u, v: g.vertices) {(v**u).in? g.edges if (u**v).in? g.edges} }
end