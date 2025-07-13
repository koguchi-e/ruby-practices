#!/usr/bin/env ruby
# frozen_string_literal: true

files = Dir['*']

sorted = files.sort_by do |f|
  [File.directory?(f) ? 0 : 1, f.downcase]
end

cells = 3

row_count = (sorted.size.to_f / cells).ceil
columns = Array.new(cells) { [] }

sorted.each_with_index do |file, index|
  col = index / row_count
  columns[col] << file
end

row_count.times do |row_idx|
  line = columns.map { |col| col[row_idx] || '' }.map { |name| name.ljust(20) }.join
  puts line.rstrip
end
