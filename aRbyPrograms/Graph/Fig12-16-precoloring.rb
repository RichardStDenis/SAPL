# Precoloring extension problem (with I/O, data consistency, and a partial coloring in bounds).
# Author: Richard St-Denis, Universite de Sherbrooke, 2022.
require 'json'
require '/home/ubuntu/ArbyACM/Graph/Theories/Fig7-graph.rb'

alloy :GraphColoring do open GraphTheory
  # Extension of the graph theory
  abstract sig Color [] {}  # Set of admissible colors
  abstract sig Coloring [   # Proper vertex coloring
    colors: (set Color),
    pi: Vertex ** Color,
    phi: Vertex ** one(Color) ] {
         Vertex.(this.pi).in? colors and
         Vertex.(this.phi).in? colors }
  pred colored[g: (one Graph), pvc: (one Coloring)] {
    all(v: g.vertices) {not (v.(pvc.phi).in? adjacent[g,v].(pvc.phi))} }
end  # Do not move this line in the previous line.

class GraphTheory::Vertex; include Arby::Ast::Sig::CustomizableName end
class GraphTheory::Graph; include Arby::Ast::Sig::CustomizableName
  def set_bounds(b)
    b[Graph] = self
    b.bound_exactly(Graph.vertices, self ** self.vertices)
    b.bound_exactly(Graph.edges, self ** self.edges)
    b end end

class GraphColoring::Color;    include Arby::Ast::Sig::CustomizableName end
class GraphColoring::Coloring; include Arby::Ast::Sig::CustomizableName
  def set_bounds(b, vertices)
    v = vertices - self.pi.flat_map {|ary| ary[0]}
    if v.empty? then v = vertices[0] end
    b[Coloring] = self
    b.bound_exactly(Coloring.colors, self ** self.colors)
    b.bound_exactly(Coloring.pi, self ** self.pi)
    b.bound(Coloring.phi, self ** self.pi, self ** v ** self.colors)
    b end end

class Array
  def exist_as_atom?(name)
    idx = self.index {|x| x.name == name}
    idx.class == Fixnum
  end
end

module GraphColoring
  class << self
    def get_graph(filename)
      File.open(filename) {|file|
        h = JSON.parse(file.read, symbolize_names: true)
        n = h[:name]
        v = h[:vertices].map {|str| GraphColoring::Vertex.new(name:str)}
        e = h[:edges].flat_map {|ary|
              if v.exist_as_atom?(ary[0]) && v.exist_as_atom?(ary[1])
                 src = v.find_by_name(ary[0])
                 dst = v.find_by_name(ary[1])
                 [[src,dst], [dst, src]]
              else puts "Data inconsistency."
                   [[v[0], v[0]]] end }
        GraphColoring::Graph.new(name:n, vertices:v, edges:e) } end

    def get_partial_coloring(filename, vertices)
      File.open(filename) {|file|
        h = JSON.parse(file.read, symbolize_names: true)
        n = h[:name]
        c = h[:colors].map {|str| GraphColoring::Color.new(name:str)}
        p = h[:partialColoring].flat_map {|ary|
              if vertices.exist_as_atom?(ary[0]) && c.exist_as_atom?(ary[1])
                 aVertex = vertices.find_by_name(ary[0])
                 aColor = c.find_by_name(ary[1])
                 [[aVertex, aColor]]
              else puts "Data insconsistency."
                   [[vertices[0], c[0]]] end }
        GraphColoring::Coloring.new(name:n, colors:c, pi:p, phi:nil) } end end end

module Main
  print "Enter a file name for a graph (without extension): "
  str = STDIN.gets.strip
  g_instance = GraphColoring.get_graph('/home/ubuntu/ArbyACM/Graph/'+str+'.json')

  print "Enter a file name for a coloring (without extension): "
  str = STDIN.gets.strip
  c_instance = GraphColoring.get_partial_coloring('/home/ubuntu/ArbyACM/Graph/'+str+'.json',
                                                  g_instance.vertices.atoms)
  bnds = Arby::Ast::Bounds.new; bnds.bound_int(-16..15)
  bnds = g_instance.set_bounds(bnds)
  bnds = c_instance.set_bounds(bnds, g_instance.vertices.atoms)
  sol = GraphColoring.solve(:colored, bnds)
  puts sol['$colored_pvc'].phi unless sol.unsat? end