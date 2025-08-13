#!/usr/bin/env ruby
# frozen_string_literal: true

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

def print_count(counts, display_options = {}, file = '', multiple_files = false)
  align_right = display_options.values.count(true) > 1 || multiple_files

  output = %i[line word byte].filter_map do |type|
    if display_options[type]
      align_right ? counts[type].to_s.rjust(3) : counts[type].to_s
    end
  end

  output << file unless file.empty?
  puts output.join(' ')
end

if file_names.empty?
  print_count(count($stdin.read), display_options)
else
  total = { line: 0, word: 0, byte: 0 }

  multiple_files = file_names.size > 1

  file_names.each do |file|
    if File.exist?(file)
      text = File.read(file)
      counts = count(text)
      print_count(counts, display_options, file, multiple_files)
      total.each_key { |k| total[k] += counts[k] }
    else
      warn "#{file}: No such file"
    end
  end

  print_count(total, display_options, 'total', multiple_files) if file_names.size > 1
end
