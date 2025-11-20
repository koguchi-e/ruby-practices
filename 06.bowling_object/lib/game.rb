#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def play
    shots = Shot.new.transforme
    Frame.new.calculate_score(shots)
  end
end

Game.new.play if __FILE__ == $PROGRAM_NAME
