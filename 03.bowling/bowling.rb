#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = scores.map { |s| s == 'X' ? 10 : s.to_i }

############################################

point = 0
index = 0
frame = 0

while frame < 10
  if shots[index] == 10
    point += 10 + shots[index + 1] + shots[index + 2]
    index += 1
  elsif shots[index] + shots[index + 1] == 10
    point += 10 + shots[index + 2]
    index += 2
  else
    point += shots[index] + shots[index + 1]
    index += 2
  end
  frame += 1
end

puts point
