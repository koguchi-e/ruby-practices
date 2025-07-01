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

  frame_score =
    if shot == 10
      shot + next_shot1 + next_shot2
    elsif shot + next_shot1 == 10
      shot + next_shot1 + next_shot2
    else
      shot + next_shot1
    end

  index += (shot == 10 ? 1 : 2)

  frame_score
end

puts point
