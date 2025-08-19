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

ls_output = !$stdin.tty? && ((Set.new(options) & Set['-l', '-w', '-c']).size >= 2 || display_options.values.none? || display_options.values.all?)

def print_count(counts, display_options = {}, file = '', multiple_files: false, ls_output: false)
  align_width_three = display_options.values.count(true) > 1 || multiple_files
  output = format_count(counts, display_options, align_width_three, ls_output)
  output << file unless file.empty?
  puts output.join(' ')
end

def format_count(counts, display_options, align_width_three, ls_output)
  %i[line word byte].filter_map do |type|
    next unless display_options[type]

    count = counts[type].to_s
    if ls_output
      count.rjust(7)
    elsif align_width_three
      count.rjust(3)
    else
      count
    end
  end
end

if file_names.empty?
  print_count(count($stdin.read), display_options, '', ls_output: ls_output)
else
  total = { line: 0, word: 0, byte: 0 }

  multiple_files = file_names.size > 1

  file_names.each do |file|
    if File.exist?(file)
      text = File.read(file)
      counts = count(text)
      print_count(counts, display_options, file, multiple_files: multiple_files, ls_output: ls_output)
      total.each_key { |k| total[k] += counts[k] }
    else
      warn "#{file}: No such file"
    end
  end

  print_count(total, display_options, 'total', multiple_files: multiple_files, ls_output: ls_output) if file_names.size > 1
end
