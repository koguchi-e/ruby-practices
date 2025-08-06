#!/usr/bin/env ruby
# frozen_string_literal: true

show_line_count = ARGV.include?('-l')
show_word_count = ARGV.include?('-w')
show_byte_count = ARGV.include?('-c')

file_names = ARGV.reject { |option| ['-l', '-w', '-c'].include?(option)}

if !show_line_count && !show_word_count && !show_byte_count
  show_line_count = show_word_count = show_byte_count = true
end

def print_counts(file, show_line_count, show_word_count, show_byte_count)
  text = File.read(file)
  line_count = text.lines.count
  word_count = text.split.size
  byte_count = text.bytesize

  output = []
  output << line_count if show_line_count
  output << word_count if show_word_count
  output << byte_count if show_byte_count
  output << file
  puts output.join(' ')
end

file_names.each do |file|
  if File.exist?(file)
    print_counts(file, show_line_count, show_word_count, show_byte_count)
  end
end
