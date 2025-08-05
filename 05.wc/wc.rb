#!/usr/bin/env ruby
# frozen_string_literal: true

show_line_count = ARGV.include?('-l')

file = File.join(__dir__, "file1.txt")

def print_line_count(file)
  line_count = File.readlines(file).size
  puts "#{line_count} #{file}"
end

print_line_count(file) if show_line_count
