#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative './bowling'

class BowlingTest < Minitest::Test
  def setup
    @old_argv = ARGV.dup
    @bowling = Bowling.new
  end

  def replace
    ARGV.replace(@old_argv)
  end

  def test_case1
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'])
    assert_equal 139, @bowling.play
  end

  def test_case2
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'])
    assert_equal 164, @bowling.play
  end

  def test_case3
    ARGV.replace(['0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'])
    assert_equal 107, @bowling.play
  end

  def test_case4
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'])
    assert_equal 134, @bowling.play
  end

  def test_case5
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'])
    assert_equal 144, @bowling.play
  end

  def test_case6
    ARGV.replace(['X,X,X,X,X,X,X,X,X,X,X,X'])
    assert_equal 300, @bowling.play
  end

  def test_case7
    ARGV.replace(['X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'])
    assert_equal 50, @bowling.play
  end
end
