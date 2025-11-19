#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'
require_relative './game'

class Bowling
  def play
    shots = Shot.new.read
    frames = Frame.new.mapping(shots).calculate_score
    points = Game.new.calculate_sum(frames)
    points
  end
end

if __FILE__ == $0
  Bowling.new.play
end
