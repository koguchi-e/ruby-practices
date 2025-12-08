#!/usr/bin/env ruby
# frozen_string_literal: true

# require_relative './entry'
# require_relative './file'
# require_relative './directory'

require 'etc'

class List
  def initialize
    # どのオプションがオンか？オプション状態を持つ
    load_entries
    parse_options
  end

  # ファイル一覧を受け取る
  def load_entries
    @enties = @show_all ? Dir.entries('.') : Dir['*']
    @enties.sort_by!(&:downcase)
  end

  def parse_options
    # ARGVでオプションを受け取る
    # オプション（a, r, l）を設定する
    options = ARGV.flat_map do |argument|
      argument.start_with?('-') ? argument[1..].chars.map { |c| "-#{c}" } : argument
    end

    @show_all = options.include?('-a')
    show_reverse = options.include?('-r')
    show_list = options.include?('-l')

    @enties.reverse! if show_reverse

    if show_list
      show_list_format(@enties)
    else
      show_column_format(@enties)
    end
  end

end
# 出力する
def run
  値 = List.new
  # オプションがあれば渡す
  値.load_entries
  値.parse_options
end
