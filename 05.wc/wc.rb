#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

options, file_names = ARGV.partition { |arg| arg.start_with?('-') }
options = options.flat_map { |opt| opt[1..].chars.map { |c| "-#{c}" } }

display_options =
  if options.empty?
    { line: true, word: true, byte: true }
  else
    {
      line: options.include?('-l'),
      word: options.include?('-w'),
      byte: options.include?('-c')
    }
  end

def count(text)
  {
    line: text.lines.count,
    word: text.split.size,
    byte: text.bytesize
  }
end

def calc_align_width(display_options, files_given, stdin_used)
  if display_options.values.count(true) == 1
    0
  elsif stdin_used
    7
  elsif display_options.values.count(true) > 1 || files_given
    3
  end
end

def format_count(counts, display_options, align_width)
  %i[line word byte].filter_map do |type|
    next unless display_options[type]

    count = counts[type].to_s
    align_width.positive? ? count.rjust(align_width) : count
  end
end

def print_count(counts, display_options = {}, file = '', align_width: 0)
  output = format_count(counts, display_options, align_width)
  output << file unless file.empty?
  puts output.join(' ')
end

stdin_used = !$stdin.tty?
files_given = file_names.size > 1
align_width = calc_align_width(display_options, files_given, stdin_used)

if file_names.empty?
  print_count(count($stdin.read), display_options, '', align_width: align_width)
else
  total = { line: 0, word: 0, byte: 0 }

  file_names.each do |file|
    if File.exist?(file)
      text = File.read(file)
      counts = count(text)
      print_count(counts, display_options, file, align_width: align_width)
      total.each_key { |k| total[k] += counts[k] }
    else
      warn "#{file}: No such file"
    end
  end

  print_count(total, display_options, 'total', align_width: align_width) if file_names.size > 1
end
