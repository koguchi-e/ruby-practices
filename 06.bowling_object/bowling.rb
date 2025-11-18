#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'
require_relative './game'

class Bowling
  def play
    shots = Shot.new.read
    scores = Frame.new.mapping(shots)
    Game.new.write(scores)
  end
end

Bowling.new.play
