#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def initialize(shots, frames)
    @shots = []
    @frames = []
  end
  def make_shots
    input_value = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }
    @shots = input_value.map { |pin| Shot.new(pin) }
  end

  def make_frames
    i = 0
    while @frames.length < 9
      if @shots[i].score == 10
        frame = Frame.new(@shots[i])
        @frames << frame
        i += 1
      else
        frame = Frame.new(@shots[i], @shots[i+1])
        @frames << frame
        i += 2
      end
    end
    last_frame = Frame.new( @shots[i], @shots[i+1], @shots[i+2] )
    @frames << last_frame
  end

  def bonus(frame_index)
    frame = @frames[frame_index]

    if frame.strike?
      bonus = @shots[frame_index + 1].score + @shots[frame_index + 2].score
      return bonus
    elsif frame.spare?
      bonus = @shots[frame_index + 2].score
      return bonus
    else
      return 0
    end
  end

  def total_score
    @frames.each_with_index.sum do |frame, i|
      frame.frame_score + bonus(i)
    end
  end
end

Game.new.play if __FILE__ == $PROGRAM_NAME
