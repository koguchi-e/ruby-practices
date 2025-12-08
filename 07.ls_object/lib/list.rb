#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './entry'
# require_relative './file'
# require_relative './directory'

require 'etc'

class List
  def initialize
    parse_options
  end

  # どのオプションが true/false かを決める・解析するだけ
  def parse_options
    options = ARGV.flat_map do |argument|
      argument.start_with?('-') ? argument[1..].chars.map { |c| "-#{c}" } : argument
    end

    @show_all = options.include?('-a')
    @show_reverse = options.include?('-r')
    @show_list = options.include?('-l')
  end

  # ファイル一覧を受け取る
  def load_entries
    if @show_all
      @entries = Dir.entries('.')
      @entries.sort_by!(&:downcase)
      p @entries
    else
      @entries = Dir['*']
    end

    @entries.sort_by!(&:downcase)
    p @entries.reverse! if @show_reverse

    return unless @show_list

    puts "total #{calc_total_blocks}"
    @entries.map { |name| Entry.new(name) }
  end

  # # -lで出す詳細情報
  # def show_list_format
  #   # List は 複数の Entry を並べるだけ。
  #   # Entry.newで一個一個のエントリを生成（Entryはファイル情報を持つ）
  #   # それを並べて出力するだけ（mapを使う）
  #   entries = filenames.map { |name| Entry.new(name) }
  #   puts "total #{calc_total_blocks}"
  #   puts entries
  # end

  def calc_total_blocks
    total_files = @entries.sum do |file|
      File.exist?(file) ? File.stat(file).blocks : 0
    end
    (total_files / 2.0).ceil
  end

  # # -l以外の表示
  # def show_column_format
  #   cells = 3
  #   row_count = (@entries.size.to_f / cells).ceil
  #   columns = Array.new(cells) { [] }

  #   @entries.each_with_index do |file, index|
  #     col = index/ row_count
  #     columns[col] << file
  #   end

  #   row_count.times do |row_idx|
  #     line = columns.map { |col| col[row_idx] || ' ' }.map { |name| name.ljust(20) }.join
  #     puts line.rstrip
  #   end
  # end

  # 解析に基づき実行する
  # def execute_options
  #   if @show_list
  #     show_list_format
  #   else
  #     show_column_format
  #   end
  # end
end

# メイン処理
list = List.new
list.load_entries
