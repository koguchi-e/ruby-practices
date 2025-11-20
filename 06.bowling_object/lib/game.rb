#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def play
    shots = Shot.new.transforme
    points = Frame.new.calculate_score(shots)
    points
  end
end

if __FILE__ == $0
  Game.new.play
end
