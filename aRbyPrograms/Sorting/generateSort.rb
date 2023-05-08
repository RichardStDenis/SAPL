#!/bin/env ruby
# encoding: utf-8

module Main
  print "Entrez n : "
  str = STDIN.gets.strip
  n = str.to_i
  print "Generate #{n} numbers..."
  puts

  for i in 1..n/5 do
    if i != 1 then print "                  "  end
    for j in 0..4 do      
      print "\"i"; print 5*(i-1)+j+1; if j == 4 && i == n/5 then print "\"" else print "\", " end;
    end
    puts
  end
  puts

 for i in 1..n/5 do
    if i != 1 then print "               "  end
    for j in 0..4 do       
      print "["
      print "\"i"; print 5*(i-1)+j+1; print "\", \"";
      print "#{rand(1..500)}"
      if j == 4 && i == n/5 then print "\"]" else print "\"], " end;
    end
    puts
  end
end