#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

def permission_string(mode)
  file_type = case mode & 0o170000
              when 0o040000 then 'd'
              when 0o100000 then '-'
              when 0o120000 then 'l'
              else '?'
              end
  perms = [6, 3, 0].map do |shift|
    bits = (mode >> shift) & 0b111
    [[0b100, 'r'], [0b010, 'w'], [0b001, 'x']].map do |mask, char|
      (bits & mask).zero? ? '-' : char
    end
  end.flatten.join
  file_type + perms
end

def show_list_format(files)
  puts "total #{calc_total_blocks(files)}"

  files.each do |file|
    stat = File.stat(file)
    mode = stat.mode
    link = stat.nlink
    user = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name
    size = stat.size
    time = stat.mtime.strftime('%b %e %H:%M')
    perm = permission_string(mode)
    name = file

    printf "%<perm>s%<link>2d %<user>-8s %<group>-8s %<size>4d %<time>s %<name>s\n",
           perm:,
           link:,
           user:,
           group:,
           size:,
           time:,
           name:
  end
end

def calc_total_blocks(files)
  total_files = files.sum do |file|
    File.exist?(file) ? File.stat(file).blocks : 0
  end
  (total_files / 2.0).ceil
end

def show_column_format(files)
  cells = 3
  row_count = (files.size.to_f / cells).ceil
  columns = Array.new(cells) { [] }

  files.each_with_index do |file, index|
    col = index / row_count
    columns[col] << file
  end

  row_count.times do |row_idx|
    line = columns.map { |col| col[row_idx] || ' ' }.map { |name| name.ljust(20) }.join
    puts line.rstrip
  end
end

options = ARGV.flat_map do |argument|
  argument.start_with?('-') ? argument[1..].chars.map { |c| "-#{c}" } : argument
end

show_all = options.include?('-a')
show_reverse = options.include?('-r')
show_list = options.include?('-l')

files = show_all ? Dir.entries('.') : Dir['*']
files.sort_by!(&:downcase)
files.reverse! if show_reverse

if show_list
  show_list_format(files)
else
  show_column_format(files)
end
