#!/usr/bin/env ruby
# frozen_string_literal: true

# require_relative './entry'
# require_relative './file'
# require_relative './directory'

require 'etc'

class List
  def initialize
    # どのオプションがオンか？オプション状態を持つ
    parse_options
  end

  # どのオプションが true/false かを決める・解析するだけ
  def parse_options
    # ARGVでオプションを受け取る
    # オプション（a, r, l）を設定する
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
      @enties = Dir.entries('.')
    else
      @enties = Dir['*']
    end

    @enties.sort_by!(&:downcase)
    @enties.reverse! if @show_reverse
    pp @enties
  end

  # 解析に基づき実行する
  # def execute_options
  #   @enties.reverse! if @show_reverse

  #   if @show_list
  #     show_list_format
  #   else
  #     show_column_format
  #   end
  # end

  # # -lで出す詳細情報
  # def show_list_format
  #   # この情報はEntryクラスに持たせる
  #   # listクラスでは出力だけ

  #   # puts "total #{calc_total_blocks(@enties)}"

  #   # @enties.each do |file|
  #   #   stat = File.stat(file)
  #   #   mode = stat.mode
  #   #   link = stat.nlink
  #   #   user = Etc.getpwuid(stat.uid).name
  #   #   group = Etc.getgrgid(stat.gid).name
  #   #   size = stat.size
  #   #   time = stat.mtime.strftime('%b %e %H:%M')
  #   #   perm = permission_string(mode)
  #   #   name = file

  #   #   printf "%<perm>s %<link>2d %<user>-8s %<group>-8s %<size>4d %<time>s %<name>s\n",
  #   #         perm:,
  #   #         link:,
  #   #         user:,
  #   #         group:,
  #   #         size:,
  #   #         time:,
  #   #         name:
  #   # end
  # end

  # # -l以外の表示
  # def show_column_format
  #   cells = 3
  #   row_count = (@enties.size.to_f / cells).ceil
  #   columns = Array.new(cells) { [] }

  #   @enties.each_with_index do |file, index|
  #     col = index/ row_count
  #     columns[col] << file
  #   end

  #   row_count.times do |row_idx|
  #     line = columns.map { |col| col[row_idx] || ' ' }.map { |name| name.ljust(20) }.join
  #     puts line.rstrip
  #   end
  # end
end

# メイン処理
list = List.new
list.load_entries
