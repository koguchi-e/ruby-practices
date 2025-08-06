#!/usr/bin/env ruby
# frozen_string_literal: true

options, file_names = ARGV.partition { |arg| arg.start_with?('-') }
options = options.flat_map { |opt| opt[1..].chars.map { |c| "-#{c}" } }

# 表示オプション設定
flags = {
  line: options.include?('-l'),
  word: options.include?('-w'),
  byte: options.include?('-c')
}
flags.transform_values! { true } if flags.values.none?  # どれも指定されていない場合はすべて true

# カウント処理
def count(text)
  {
    line: text.lines.count,
    word: text.split.size,
    byte: text.bytesize
  }
end

# 出力処理（右寄せ対応）
def print_count(counts, flags, file = '', widths = {})
  fields = [:line, :word, :byte].filter { |key| flags[key] }
  output = fields.map { |key| counts[key].to_s.rjust(widths[key] || 0) }
  output << file unless file.empty?
  puts output.join(' ')
end

# 標準入力処理
if file_names.empty?
  counts = count($stdin.read)
  print_count(counts, flags)
else
  # 各ファイル処理
  count_list = []
  file_names.each do |file|
    if File.exist?(file)
      counts = count(File.read(file)).merge(file: file)
      count_list << counts
    else
      warn "#{file}: No such file"
    end
  end

  # 桁幅計算
  widths = {}
  [:line, :word, :byte].each do |key|
    next unless flags[key]
    widths[key] = count_list.map { |c| c[key].to_s.size }.max
  end

  # 出力
  count_list.each { |c| print_count(c, flags, c[:file], widths) }

  # total出力（複数ファイル時）
  if count_list.size > 1
    total = {
      line: count_list.sum { |c| c[:line] },
      word: count_list.sum { |c| c[:word] },
      byte: count_list.sum { |c| c[:byte] }
    }
    print_count(total, flags, 'total', widths)
  end
end
