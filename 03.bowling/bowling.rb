#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  shots << (s == 'X' ? 10 : s.to_i)
end

############################################

## ここはフレームに分けることのみに特化
# フレームを計算する・フレームは最大10まで

index = 0
frames = []

# framesが10以下まで計算を続ける
while frames.size < 10
  if shots[index] == 10
    # ストライクなら10を入れて終了、2投はなし
    frames << [10]
    index += 1
  else
    # それ以外は次の数を2投目としてセット
    # || 0 : 値がなければ0を使う
    frames << [shots[index], shots[index + 1] || 0]
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

################################################

## ここから得点計算

point = 0

frames[0..9].each_with_index do |frame, i|
  if i == 9
    point += frame.sum
    next
  end

  # ストライク
  if frame[0] == 10
    all_throws = frames.flatten
    throw_index = frames[0...i].flatten.size

    next_number = all_throws[throw_index + 1] || 0
    next_number2 = all_throws[throw_index + 2] || 0
    point += 10 + next_number + next_number2

  # スペア
  elsif frame.sum == 10
    next_number = frames[i + 1] ? frames[i + 1][0] : 0
    point += 10 + next_number

  # それ以外　
  else
    point += frame.sum
  end
end

puts point
