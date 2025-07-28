#!/usr/bin/env ruby
# frozen_string_literal: true

show_all = ARGV.include?('-a')
show_reverse = ARGV.include?('-r')
show_list = ARGV.include?('-l')

files = show_all ? Dir.entries('.') : Dir['*']
files.sort_by!(&:downcase)
files.reverse! if show_reverse

if show_list
  total_files = files.sum do |file| 
    File.exist?(file) ? File.stat(file).blocks : 0 
  end
  total_blocks = (total_files / 2.0).ceil
  puts "total #{total_blocks}"

  files.each do |file|
    type_char = case File.ftype(file)
                  when "directory" then "d"
                  when "file" then "-"
                end
    permission =  File.stat(file).mode
    permission = sprintf("%o", 33188)

    hard_link = File.stat(file).nlink

    require 'etc'
    owner_user = Etc.getpwuid(File.stat(file).uid).name
    owner_group = Etc.getgrgid(File.stat(file).gid).name

    bites = File.size(file)

    time_stamp = File.atime(file)
    formatted_time = time_stamp.strftime("%b %e %H:%M")

    puts "#{type_char}#{permission} #{hard_link} #{owner_user} #{owner_group} #{bites} #{formatted_time} #{file}"
  end
else
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
end
