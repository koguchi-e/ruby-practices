#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './entry'

require 'etc'

class List
  def initialize
    parse_options
  end

  def parse_options
    options = ARGV.flat_map do |argument|
      argument.start_with?('-') ? argument[1..].chars.map { |c| "-#{c}" } : argument
    end

    @show_all = options.include?('-a')
    @show_reverse = options.include?('-r')
    @show_list = options.include?('-l')
  end

  def load_entries
    if @show_all
      @entries = Dir.entries('.')
      @entries.sort_by!(&:downcase)
    else
      @entries = Dir['*']
    end

    @entries.sort_by!(&:downcase)
    @entries.reverse! if @show_reverse

    if @show_list
      puts "total #{calc_total_blocks}"
      @entries.map { |name| Entry.new(name) }
    else
      show_column_format
    end
  end

  def calc_total_blocks
    total_files = @entries.sum do |file|
      File.exist?(file) ? File.stat(file).blocks : 0
    end
    (total_files / 2.0).ceil
  end

  def show_column_format
    cells = 3
    row_count = (@entries.size.to_f / cells).ceil
    columns = Array.new(cells) { [] }

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

list = List.new
list.load_entries
