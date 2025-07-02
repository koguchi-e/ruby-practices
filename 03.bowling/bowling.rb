#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = scores.map { |s| s == 'X' ? 10 : s.to_i }

index = 0

point = 10.times.sum do
  shot = shots[index]
  next_shot1 = shots[index + 1]
  next_shot2 = shots[index + 2]

  strike = shot == 10
  spare = shot + next_shot1 == 10

  frame_score =
    shot + next_shot1 + (strike || spare ? next_shot2 : 0)

  index += (strike ? 1 : 2)

  frame_score
end

puts point
