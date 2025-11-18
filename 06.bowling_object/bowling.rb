#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'
require_relative './game'

class Bowling
  def play
    shots = Shot.new.read
    scores = Frame.new.mapping(shots)
    points = Game.new.calculate_sum(scores)
    puts points
  end
end

Bowling.new.play
