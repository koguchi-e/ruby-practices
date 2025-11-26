#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def calculate_score
    input_value = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }
    shots = input_value.map { |pin| Shot.new(pins) }
    frames << Frame.new(shots[i], shots[i+1])
    
    
  end
end

Game.new.play if __FILE__ == $PROGRAM_NAME
