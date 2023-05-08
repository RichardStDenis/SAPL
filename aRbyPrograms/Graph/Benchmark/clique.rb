# Graph Coloring
# Author: Richard St-Denis, Universite de Sherbrooke, 2021.
require 'json'
require '/home/ubuntu/ArbyACM/Graph/Theories/Fig7-graph.rb'

alloy :GraphClique do open GraphTheory

  pred greaterClique[g: Graph, old: (set Vertex), c: (set Vertex)] {
    maximal_clique(g, c) and
    not (old == c) and old.size < c.size }

  pred exactClique[g: Graph, ref: (set Vertex), c: (set Vertex)] {
    maximal_clique(g, c) and ref.size == c.size }

  pred c__greaterClique[g: (one Graph), r: (set Vertex)] {
    greaterClique(g, GraphClique.clq, r) }

  pred c__exactClique[g: (one Graph), r: (set Vertex)] {
    exactClique(g, GraphClique.clq, r) }
end

class GraphTheory::Vertex; include Arby::Ast::Sig::CustomizableName end
class GraphTheory::Graph; include Arby::Ast::Sig::CustomizableName
  def set_bounds(b)
    b[Graph] = self
    b.bound_exactly(Graph.vertices, self ** self.vertices)
    b.bound_exactly(Graph.edges, self ** self.edges)
    b end end

class Array
  def exist_as_atom?(name)
    idx = self.index {|x| x.name == name}
    idx.class == Fixnum
  end
end

module GraphClique
  class << self
    attr_accessor :clq
    def get_graph(filename)
      File.open(filename) {|file|
        h = JSON.parse(file.read, symbolize_names: true)
        n = h[:name]
        v = h[:vertices].map {|str| GraphClique::Vertex.new(name: str)}
        e = h[:edges].flat_map {|ary|
              if v.exist_as_atom?(ary[0]) && v.exist_as_atom?(ary[1])
                 src = v.find_by_name(ary[0])
                 dst = v.find_by_name(ary[1])
                 [[src,dst], [dst, src]]
              else puts "Data insconsistency."
                   [[v[0], v[0]]] end }
        GraphClique::Graph.new(name:n, vertices:v, edges:e) } end end end

module Main
  print "Enter a file name for a graph (without extension): "
  $str = STDIN.gets.strip
  g_instance = GraphClique.get_graph('/home/ubuntu/ArbyACM/Graph/Benchmark/'+$str+'.json')
  puts g_instance.name
  GraphClique.clq = g_instance.vertices
  puts GraphClique.clq
 
  t = Time.now
  puts "A maximal clique"
  bnds = Arby::Ast::Bounds.from_atoms(g_instance)
  bnds.bound_int(0..63)
  sol =  GraphClique.solve(:maximal_clique, bnds)
  puts "*** Solving time: #{sol.solving_time}s"
  puts GraphClique.clq = sol['$maximal_clique_c']

  i= 1
  loop do
    sol = GraphClique.solve(:c__greaterClique, bnds)
    puts "*** Solving time: #{sol.solving_time}s"
    break unless sol.satisfiable?
    print "Iteration #{i}: ";
    puts GraphClique.clq = sol['$c__greaterClique_r']
    i = i + 1  end
  print "Size of the mamimum clique: "
  puts max = GraphClique.clq.size

  sol = GraphClique.solve(:c__exactClique, bnds)
  puts "*** Solving time: #{sol.solving_time}s"
  i= 0
  while sol.satisfiable? do
    puts sol['$c__exactClique_r']; i = i + 1;
    sol = sol.next  end
  print "Number of mamimum cliques: "; puts i
  puts "*** Execution time: #{Time.now - t}s" end
