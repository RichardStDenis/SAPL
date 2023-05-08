# Proper vertex coloring problem (without I/O and anonymous colors).
# Author: Richard St-Denis, Universite de Sherbrooke, 2022.
 
require '/home/ubuntu/ArbyACM/Graph/Theories/Fig7-graph.rb'
alloy :GraphColoring do open GraphTheory
  # Extension of the graph theory
  abstract sig Color [] {}  # Set of admissible colors
  abstract sig Coloring [   # Proper vertex coloring
    colors: (set Color),
    phi: Vertex ** one(Color) ] {Vertex.(this.phi).in? colors}
  pred colored[g: (one Graph), pvc: (one Coloring)] {
    all(v: g.vertices) {not (v.(pvc.phi).in? adjacent[g,v].(pvc.phi))} }
  # Instance of the proper vertex coloring problem
  one sig V1 extends Vertex [] {}
  one sig V2 extends Vertex [] {}
  one sig V3 extends Vertex [] {}
  one sig V4 extends Vertex [] {}
  one sig V5 extends Vertex [] {}
  one sig G extends Graph [] {vertices == V1 + V2 + V3 + V4 + V5}
  fact {G.(edges) == sym_closure[V1**V2 + V1**V3 + V1**V4 + V1**V5 + V2**V3 + V4**V5]}
  # Putting "edges == sym_closure[V1**V2 + V1**V3 + V1**V4 + V1**V5 + V2**V3 + V4**V5]"
  # in the fact of G is not accepted by ARby 
  # Commands for solving an instance of the proper vertex coloring problem
  assertion c__undirected {undirected[G]}
  check :c__undirected, 1, Int => 5
  run :colored, 1, Int => 5, Color=>exactly(6) end
module Main
  cntrex = GraphColoring.check_c__undirected
  if cntrex.sat? then puts "The predicate is violated." end
  sol = GraphColoring.run_colored; puts sol['$colored_pvc'].phi unless sol.unsat? end
#File.open('/home/ubuntu/TEMP/pure_alloy.als', 'w') {|f| f << GraphColoring::to_als} 