#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './entry'
require_relative './option'

class List
  def initialize
    option = Option.new
    @display_entries = option.sort_entries
    @option = option
  end

  def output_list
    if @option.show_list?
      puts "total #{calc_total_blocks}"
      @display_entries.each do |name|
        puts Entry.new(name).entry_information
      end
    else
      show_column_format
    end
  end

  private

  def calc_total_blocks
    total_files = @display_entries.sum do |file|
      File.exist?(file) ? File.stat(file).blocks : 0
    end
    (total_files / 2.0).ceil
  end

  def show_column_format
    cells = 3
    row_count = (@display_entries.size.to_f / cells).ceil
    columns = Array.new(cells) { [] }

    @display_entries.each_with_index do |file, index|
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
list.output_list
