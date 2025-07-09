#!/usr/bin/env ruby

files = Dir.children(".").reject { |f| f.start_with?(".") }

sorted = files.sort_by do |f|
  File.directory?(f) ? 0 : 1
end

puts sorted.join("  ")
