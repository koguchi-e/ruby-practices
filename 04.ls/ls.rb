#!/usr/bin/env ruby
# frozen_string_literal: true

files = Dir.children('.').reject { |f| f.start_with?('.') }

sorted = files.sort_by do |f|
  [File.directory?(f) ? 0 : 1, f.downcase]
end

rows = (sorted.size.to_f / 3).ceil

columns_array = Array.new(3) { [] }

sorted.each_with_index do |file, index|
  col = index / rows
  columns_array[col] << file
end

(0...rows).each do |row_idx|
  line = columns_array.map { |col| col[row_idx] || '' }.map { |name| name.ljust(20) }.join
  puts line.rstrip
end
