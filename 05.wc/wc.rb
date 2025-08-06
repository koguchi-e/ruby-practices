#!/usr/bin/env ruby
# frozen_string_literal: true

options, file_names = ARGV.partition { |arg| arg.start_with?('-') }
options = options.flat_map { |opt| opt[1..].chars.map { |c| "-#{c}" } }

show_line_count = options.include?('-l')
show_word_count = options.include?('-w')
show_byte_count = options.include?('-c')

if !show_line_count && !show_word_count && !show_byte_count
  show_line_count = show_word_count = show_byte_count = true
end

def count_from_text(text, file = '')
  line_count = text.lines.count
  word_count = text.split.size
  byte_count = text.bytesize

  output = []
  output << line_count if $show_line_count
  output << word_count if $show_word_count
  output << byte_count if $show_byte_count
  output << file unless file.empty?
  puts output.join(' ')
end

$show_line_count = show_line_count
$show_word_count = show_word_count
$show_byte_count = show_byte_count

if file_names.empty?
  input_text = $stdin.read
  count_from_text(input_text)
else
  file_names.each do |file|
    if File.exist?(file)
      text = File.read(file)
      count_from_text(text, file)
    else
      warn "#{file}: No such file"
    end
  end
end

