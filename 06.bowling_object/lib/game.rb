#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def initialize
    @frames = []
    make_frames
    link_frames
  end

  def calculate_total_score
    @frames.sum(&:total_score)
  end

  private



  def link_frames
    @frames.each_cons(2) do |current, nxt|
      current.next_frame = nxt
    end
  end
end

puts Game.new.calculate_total_score if __FILE__ == $PROGRAM_NAME
