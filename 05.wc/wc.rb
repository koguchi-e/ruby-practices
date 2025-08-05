#!/usr/bin/env ruby
# frozen_string_literal: true

show_line_count = ARGV.include?('-l')
show_word_count = ARGV.include?('-w')

file = File.join(__dir__, "file3.txt")

def print_line_count(file)
  line_count = File.readlines(file).size
  puts "#{line_count} #{file}"
end

def print_word_count(file)
  text = File.read(file)
  word_count = text.split.size
  puts "#{word_count} #{file}"
end

print_line_count(file) if show_line_count
print_word_count(file) if show_word_count
