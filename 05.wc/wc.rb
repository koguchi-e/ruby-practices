#!/usr/bin/env ruby
# frozen_string_literal: true

options, file_names = ARGV.partition { |arg| arg.start_with?('-') }
options = options.flat_map { |opt| opt[1..].chars.map { |c| "-#{c}" } }

show_line_count = options.include?('-l')
show_word_count = options.include?('-w')
show_byte_count = options.include?('-c')
show_line_count = show_word_count = show_byte_count = true unless show_line_count || show_word_count || show_byte_count

display_options = { line: show_line_count, word: show_word_count, byte: show_byte_count }

def count(text)
  {
    line: text.lines.count,
    word: text.split.size,
    byte: text.bytesize
  }
end

def print_count(counts, display_options = {}, file = '')
  output = []
  output << counts[:line] if display_options[:line]
  output << counts[:word] if display_options[:word]
  output << counts[:byte] if display_options[:byte]
  output << file unless file.empty?
  puts '   ' + output.join('   ')
end

if file_names.empty?
  print_count($stdin.read, display_options)
else
  total = { line: 0, word: 0, byte: 0 }

  file_names.each do |file|
    if File.exist?(file)
      text = File.read(file)
      counts = count(text)
      print_count(counts, display_options, file)

      total.each_key { |k| total[k] += counts[k] }
    else
      warn "#{file}: No such file"
    end
  end

  if file_names.size > 1
    print_count(total, display_options, 'total')
  end
end
