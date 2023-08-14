# Sorting (main program).
# Author: Richard St-Denis, Universite de Sherbrooke, 2023.
require 'date'
require 'json'
require '/home/ubuntu/ArbyACM/Sorting/Theories/sortingTheory.rb'

alloy :Problem do
  open Sorting
  pred c__sort[a: (one ArrayOfInt), p: (one Permutation),
               v: (set Index ** one(Int))] { v == sort[a, p] }
end

class Sorting::Index 
  include Arby::Ast::Sig::CustomizableName end
class Sorting::ArrayOfInt
  include Arby::Ast::Sig::CustomizableName end
class Sorting::Permutation
  include Arby::Ast::Sig::CustomizableName end

module Problem
  class << self
    def get_input_data(filename)
      File.open(filename) { |f|
        h = JSON.parse(f.read, symbolize_names: true)
        r= 0;   n = h[:name]
        t = h[:indices].map { |str|
              l = Sorting::Index.new(name:str, rank:r); r += 1; l }
        l = h[:list].map { |ary|
              k = t.find_by_name(ary[0])
              v = ary[1].to_i
              [k, v] }
        Sorting::ArrayOfInt.new(name:n, ub:t.last, v:l) } end end end

module Main
  print "Enter a file name (without extension): "
  $str = STDIN.gets.strip
  instance = Problem.get_input_data('/home/ubuntu/ArbyACM/Sorting/'+$str+'.json')
  File.open('/home/ubuntu/TEMP/pure_alloy.als', 'w') {|f| f << Problem.to_als }

  t = Time.now
  puts instance.v
  puts instance.v.size
  bnds = Arby::Ast::Bounds.from_atoms(instance)
  bnds.bound_int(0..511)
  sol = Problem.solve(:c__sort, bnds)
  puts sol["$c__sort_v"] 
  puts "*** Execution time: #{Time.now - t}s"
#  File.open('/home/ubuntu/TEMP/pure_alloy.als', 'w') {|f| f << Problem.to_als }
end