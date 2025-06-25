#!/usr/bin/env ruby
require 'debug'

# score：入力した点数を取得
score = ARGV[0]

# scores:スコアを分割して配列にする
scores = score.split(',')

# Xを10に変換、それ以外は数字にする
# shotsという配列に入れる
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
  else
    shots << s.to_i
  end
end
p shots

############################################

## ここはフレームに分けることのみに特化

# フレームを計算する・フレームは最大10まで
# index:shots配列が今何番目かをカウントする
index = 0
frames = []
# framesが10以下まで計算を続ける
while frames.size < 10 do
  if shots[index] == 10
    # ストライクなら10を入れて終了、2投はなし
    frames << [10]
    index += 1
  else
    # それ以外は次の数を2投目としてセット
    # || 0 : 値がなければ0を使う
    frames << [shots[index], shots[index +1] || 0]
    index += 2
  end
end

# 10フレーム目(frames[9])がストライク・スペアの時
# ボーナス点を10フレーム目に追加（最大3つになる）
if frames[9].sum >= 10
  # 1投目を追加
  frames[9] << shots[index]
  # もしストライクなら2投目を追加
  frames[9] << shots[index + 1] || 0 if frames[9][0] == 10
end

p frames

################################################

## ここから得点計算

point = 0

frames[0..9].each_with_index do |frame, i|
  if i == 9
    puts "10フレーム目：#{point} + #{frame.sum}"
    point += frame.sum
    next
  end

  # ストライク
  if frame[0] == 10
    all_throws = frames.flatten
    throw_index = frames[0...i].flatten.size

    next_number = all_throws[throw_index + 1] || 0
    next_number2 = all_throws[throw_index + 2] || 0
    puts "ストライク：#{point} + #{frame[0]} + #{next_number} + #{next_number2}"
    point += 10 + next_number + next_number2 
    puts point

  # スペア
  elsif frame.sum == 10
    next_number = frames[i + 1] ? frames[i + 1][0] : 0
    puts "スペア：#{point} + 10 + next_number(#{next_number})"
    point += 10 + next_number
    puts point
    
  # それ以外
  else
    puts "それ以外：#{point} + #{frame.sum}"
    point += frame.sum
    puts point
  end
end

puts point
