#!/usr/bin/ruby  -w
require 'find'

File.open("1.txt").each do |line| 
puts line.gsub(/^\:\s/,"").gsub(/\:.*\;\./," ").gsub(/\|/,"").gsub(/\[.*\]/,"").gsub(/[0][x]/,"")

end
