#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './file_metadata'
require_relative './option'

class LsCommand
  def initialize
    @option = Option.new
    load_entries
  end

  def output_list
    if @option.show_long?
      puts "total #{calc_total_blocks}"
      @entries.each do |name|
        @metadata = FileMetadata.new(name)
        puts format_long_line
      end
    else
      show_column_format
    end
  end

  private

  def load_entries
    @entries = if @option.show_all?
                 Dir.entries('.')
               else
                 Dir['*']
               end
    @entries.sort_by!(&:downcase)
    @entries.reverse! if @option.show_reverse?
  end

  def calc_total_blocks
    total_files = @entries.sum do |file|
      File.exist?(file) ? File.stat(file).blocks : 0
    end
    (total_files / 2.0).ceil
  end

  def format_long_line
    link = @metadata.link
    user = @metadata.user_name
    group = @metadata.user_group
    size = @metadata.file_size
    time = @metadata.time_stamp
    perm = permission_string
    name = @metadata.name
    format("%<perm>s %<link>2d %<user>-8s %<group>-8s %<size>4d %<time>s %<name>s\n",
           perm:,
           link:,
           user:,
           group:,
           size:,
           time:,
           name:)
  end

  def permission_string
    mode = @metadata.mode
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

  CELLS = 3
  def show_column_format
    row_count = (@entries.size.to_f / CELLS).ceil
    columns = Array.new(CELLS) { [] }

    @entries.each_with_index do |file, index|
      col = index.div(row_count)
      columns[col] << file
    end

    row_count.times do |row_idx|
      line = columns.map { |col| col[row_idx] || ' ' }.map { |name| name.ljust(20) }.join
      puts line.rstrip
    end
  end
end

list = LsCommand.new
list.output_list
