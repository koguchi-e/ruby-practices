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
    input_value = ARGV[0].split(',')
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
        @frames << Frame.new(*@shots[i..(i + 1)])
        i += 2
      end
    end
    @frame_first_shot_index << i
    last_shots = @shots[i..]
    last_frame = Frame.new(*last_shots)
    @frames << last_frame
  end

  def calculate_total_score
    @total_score = @frames.each_with_index.sum do |frame, index|
      if index == 9
        frame.frame_score
      else
        next_shot_index = @frame_first_shot_index[index + 1]
        frame = @frames[index]

        if frame.strike?
          next_shot1 = @shots[next_shot_index].score
          next_shot2 = @shots[next_shot_index + 1].score
        elsif frame.spare?
          next_shot1 = @shots[next_shot_index].score
        else
          0
        end

        frame.total_score(next_shot1, next_shot2)
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.make_shots
  game.make_frames
  puts game.calculate_total_score
end
