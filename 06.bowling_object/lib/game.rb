#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def initialize
    @shots = []
    @frames = []
    @frame_first_shot_index = []
  end
  def make_shots
    input_value = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }
    @shots = input_value.map { |pin| Shot.new(pin) }
  end

  def make_frames
    i = 0

    while @frames.length < 9
      @frame_first_shot_index << i

      if @shots[i].score == 10
        @frames << Frame.new(@shots[i])
        i += 1
      else
        @frames << Frame.new(@shots[i], @shots[i+1])
        i += 2
      end
    end
    @frame_first_shot_index << i
    last_shots = @shots[i..-1]
    last_frame = Frame.new(*last_shots)
    @frames << last_frame
  end

  def bonus(frame_index)
    return 0 if frame_index == 9

    start = @frame_first_shot_index[frame_index]
    frame = @frames[frame_index]

    if frame.strike?
      return @shots[start + 1].score + @shots[start + 2].score
    elsif frame.spare?
      return @shots[start + 2].score
    else
      return 0
    end
  end

  def calculate_total_score
    total_score = @frames.each_with_index.sum do |frame, index|
      frame.frame_score + bonus(index)
    end
    puts total_score
  end
end

if __FILE__ == $0
  game = Game.new
  game.make_shots
  game.make_frames
  game.calculate_total_score
end
