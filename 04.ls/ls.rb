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

  require 'etc'

  def permission_string(mode)
    file_type = case mode & 0o170000
                when 0o040000 then 'd'
                when 0o100000 then '-'
                when 0o120000 then 'l'
                else '?'
                end
    perms = +''
    [6, 3, 0].each do |shift|
      bits = (mode >> shift) & 0b111
      perms << ((bits & 0b100).zero? ? '-' : 'r')
      perms << ((bits & 0b010).zero? ? '-' : 'w')
      perms << ((bits & 0b001).zero? ? '-' : 'x')
    end
    file_type + perms
  end

  files.each do |file|
    stat = File.stat(file)
    mode = stat.mode
    hard_link = stat.nlink
    owner_user = Etc.getpwuid(stat.uid).name
    owner_group = Etc.getgrgid(stat.gid).name
    file_size = stat.size
    time_stamp = stat.mtime.strftime('%b %e %H:%M')

    printf "%<perm>s %<link>2d %<user>-8s %<group>-8s %<size>4d %<time>s %<name>s\n",
           perm: permission_string(mode),
           link: hard_link,
           user: owner_user,
           group: owner_group,
           size: file_size,
           time: time_stamp,
           name: file
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
