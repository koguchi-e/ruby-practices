#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './file_metadata'
require_relative './command_line_option'

class LsCommand
  def initialize
    @command_line_option = CommandLineOption.new
    @entries = load_entries
  end

  def output_list
    if @command_line_option.show_long?
      puts "total #{calc_total_blocks}"
      output_long_list
    else
      show_column_format
    end
  end

  private

  def output_long_list
    metadatas = @entries.map { |name| FileMetadata.new(name) }
    link_width = metadatas.map { |m| m.link.to_s.length }.max
    user_column_width = metadatas.map { |m| m.user_name.length }.max
    group_column_width = metadatas.map { |m| m.user_group.length }.max
    file_size_width = metadatas.map { |m| m.file_size.to_s.length }.max

    metadatas.each do |metadata|
      puts format_long_line(metadata, link_width, user_column_width, group_column_width, file_size_width)
    end
  end

  def load_entries
    entries = if @command_line_option.show_all?
                Dir.entries('.')
              else
                Dir['*']
              end
    entries.sort_by!(&:downcase)
    entries.reverse! if @command_line_option.show_reverse?
    entries
  end

  def calc_total_blocks
    total_files = @entries.sum do |file|
      File.exist?(file) ? File.stat(file).blocks : 0
    end
    (total_files / 2.0).ceil
  end

  def formatted_time(metadata)
    now = Time.now
    half_year_seconds = 60 * 60 * 24 * 30 * 6
    if (now - metadata.time_stamp).abs >= half_year_seconds
      metadata.time_stamp.strftime('%b %e  %G')
    else
      metadata.time_stamp.strftime('%b %e %H:%M')
    end
  end

  def format_long_line(metadata, link_width, user_column_width, group_column_width, file_size_width)
    perm = permission_string(metadata)
    link = metadata.link.to_s.rjust(link_width)
    user = metadata.user_name.ljust(user_column_width)
    group = metadata.user_group.ljust(group_column_width)
    size = metadata.file_size.to_s.rjust(file_size_width)
    time = formatted_time(metadata)
    name = metadata.name
    format("%<perm>s %<link>s %<user>s %<group>s %<size>s %<time>s %<name>s\n",
           perm:,
           link:,
           user:,
           group:,
           size:,
           time:,
           name:)
  end

  def permission_string(metadata)
    mode = metadata.mode
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

    names = columns.flatten
    max_width = names.map(&:length).max

    row_count.times do |row_idx|
      line = columns.map { |col| col[row_idx] || ' ' }.map { |name| name.ljust(max_width) }.join(' ')
      puts line
    end
  end
end

list = LsCommand.new
list.output_list
