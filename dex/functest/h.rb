#!/usr/bin/ruby  -w
require 'find'

fin=File.open("functest.txt")
fout=File.new("h1.txt","w")
fin.each do |line|
fout.puts line.scan(/.*\|\[.*/)
fout.puts line.scan(/.*\:.*\|[0-9a-z]{4}\:.*\;\..*\:\(.*\)/) #地址
fout.puts line.scan(/.*[a-z]{4}\=.*/) #行号
end
fin.close
fout.close

fi=File.open("h1.txt")
fo=File.new("h2.txt","w")
fi.each do |lines|
fo.puts lines.sub(/\:\s.*\|/,"    ").gsub(/\:.*\,\s/,"    ").gsub(/\;\./,"  ").gsub(/\[.*\]/,"").gsub(/[0][x]/,"")
end
fi.close
fo.close

