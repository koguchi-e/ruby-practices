#!/usr/bin/env ruby
# frozen_string_literal: true

show_all = ARGV.include?('-a')
files = show_all ? Dir.entries('.') : Dir['*']

files.sort_by!(&:downcase)

CELLS = 3

row_count = (files.size.to_f / CELLS).ceil
columns = Array.new(CELLS) { [] }

files.each_with_index do |file, index|
  col = index / row_count
  columns[col] << file
end

row_count.times do |row_idx|
  line = columns.map { |col| col[row_idx] || '' }.map { |name| name.ljust(20) }.join
  puts line.rstrip
end
