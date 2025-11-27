#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class GameTest < Minitest::Test
  def setup
    @old_argv = ARGV.dup
  end

  def replace
    ARGV.replace(@old_argv)
  end

  def run_game(arg)
    ARGV.replace([arg])
    game = Game.new
    game.make_shots
    game.make_frames
    game.calculate_total_score
  end

  def test_case1
    assert_equal 139, run_game('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
  end

  def test_case2
    assert_equal 164, run_game('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
  end

  def test_case3
    assert_equal 107, run_game('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
  end

  def test_case4
    assert_equal 134, run_game('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
  end

  def test_case5
    assert_equal 144, run_game('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
  end

  def test_case6
    assert_equal 300, run_game('X,X,X,X,X,X,X,X,X,X,X,X')
  end

  def test_case7
    assert_equal 50, run_game('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0')
  end
end
