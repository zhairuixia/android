#!/usr/bin/ruby  -w
require 'find'

File.open("dex.txt").each do |line|  
puts(line.scan(/.*\|\[.*/)) 
puts(line.scan(/\.*\:.*\|[0-9a-z]{4}\:.*\;\..*\:\(.*\)/))  #地址
puts(line.scan(/.*[a-z]{4}\=.*/)) #行号
end



