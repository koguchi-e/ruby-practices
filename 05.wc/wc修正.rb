#!/usr/bin/env ruby
# frozen_string_literal: true

options, file_names = ARGV.partition { |arg| arg.start_with?('-') }
options = options.flat_map { |opt| opt[1..].chars.map { |c| "-#{c}" } }

flags = {
  line: options.include?('-l'),
  word: options.include?('-w'),
  byte: options.include?('-c')
}
flags.transform_values! { true } if flags.values.none?

display_options = { line: show_line_count, word: show_word_count, byte: show_byte_count }

def count(text)
  {
    line: text.lines.count,
    word: text.split.size,
    byte: text.bytesize
  }
end

def print_count(counts, flags, file = '', widths = {})
  fields = [:line, :word, :byte].filter { |key| flags[key] }
  output = fields.map { |key| counts[key].to_s.rjust(widths[key] || 0) }
  output << file unless file.empty?
  puts output.join(' ')
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
