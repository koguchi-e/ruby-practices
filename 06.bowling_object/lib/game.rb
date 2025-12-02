#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def initialize
    @frames = []
  end

  def make_frames
    input_values = ARGV[0].split(',')

    i = 0

    9.times do
      if input_values[i] == 'X'
        @frames << Frame.new([input_values[i]])
        i += 1
      else
        @frames << Frame.new([input_values[i], input_values[i + 1]])
        i += 2
      end
    end

    @frames << Frame.new(input_values[i..])
  end

  def link_frames
    @frames.each_cons(2) do |current, nxt|
      current.next_frame = nxt
    end
  end

  def calculate_total_score
    @frames.sum(&:total_score)
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.make_frames
  game.link_frames
  puts game.calculate_total_score
end
