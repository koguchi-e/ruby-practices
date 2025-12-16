#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_command'
require 'pathname'

class LsCommandTest < Minitest::Test
  TEST_PATH = Pathname('./fixtures')

  def setup
    @old_argv = ARGV.dup
  end

  def replace
    ARGV.replace(@old_argv)
  end

  def make_lists(arg)
    ARGV.replace(arg)

    Dir.chdir(TEST_PATH) do
      stdout, _stderr = capture_io do
        LsCommand.new.output_list
      end
      return stdout
    end
  end

  def test_all
    expected = <<~TEXT
      .                   Dir2                file3.txt
      ..                  file1.txt
      Dir1                file2.txt
    TEXT
    assert_equal expected, make_lists(['-a'])
  end

  def test_reverse
    expected = <<~TEXT
      file3.txt           file1.txt           Dir1
      file2.txt           Dir2
    TEXT
    assert_equal expected, make_lists(['-r'])
  end

  def test_lists
    expected = <<~TEXT
      total 20
      drwxr-xr-x  2 koguchi  koguchi  4096 Dec  8 14:39 Dir1
      drwxr-xr-x  2 koguchi  koguchi  4096 Dec  8 14:39 Dir2
      -rw-r--r--  1 koguchi  koguchi   101 Dec  8 14:36 file1.txt
      -rw-r--r--  1 koguchi  koguchi   102 Dec  8 14:36 file2.txt
      -rw-r--r--  1 koguchi  koguchi   102 Dec  8 14:38 file3.txt
    TEXT
    assert_equal expected, make_lists(['-l'])
  end

  def test_ar
    expected = <<~TEXT
      file3.txt           Dir2                .
      file2.txt           Dir1
      file1.txt           ..
    TEXT
    assert_equal expected, make_lists(['-ar'])
  end

  def test_al
    expected = <<~TEXT
      total 28
      drwxr-xr-x  4 koguchi  koguchi  4096 Dec  9 16:43 .
      drwxr-xr-x  3 koguchi  koguchi  4096 Dec 16 13:52 ..
      drwxr-xr-x  2 koguchi  koguchi  4096 Dec  8 14:39 Dir1
      drwxr-xr-x  2 koguchi  koguchi  4096 Dec  8 14:39 Dir2
      -rw-r--r--  1 koguchi  koguchi   101 Dec  8 14:36 file1.txt
      -rw-r--r--  1 koguchi  koguchi   102 Dec  8 14:36 file2.txt
      -rw-r--r--  1 koguchi  koguchi   102 Dec  8 14:38 file3.txt
    TEXT
    assert_equal expected, make_lists(['-al'])
  end

  def test_rl
    expected = <<~TEXT
      total 28
      -rw-r--r--  1 koguchi  koguchi   102 Dec  8 14:38 file3.txt
      -rw-r--r--  1 koguchi  koguchi   102 Dec  8 14:36 file2.txt
      -rw-r--r--  1 koguchi  koguchi   101 Dec  8 14:36 file1.txt
      drwxr-xr-x  2 koguchi  koguchi  4096 Dec  8 14:39 Dir2
      drwxr-xr-x  2 koguchi  koguchi  4096 Dec  8 14:39 Dir1
      drwxr-xr-x  3 koguchi  koguchi  4096 Dec 16 13:52 ..
      drwxr-xr-x  4 koguchi  koguchi  4096 Dec  9 16:43 .
    TEXT
    assert_equal expected, make_lists(['-rl'])
  end

  def test_alr
    expected = <<~TEXT
      total 28
      -rw-r--r--  1 koguchi  koguchi   102 Dec  8 14:38 file3.txt
      -rw-r--r--  1 koguchi  koguchi   102 Dec  8 14:36 file2.txt
      -rw-r--r--  1 koguchi  koguchi   101 Dec  8 14:36 file1.txt
      drwxr-xr-x  2 koguchi  koguchi  4096 Dec  8 14:39 Dir2
      drwxr-xr-x  2 koguchi  koguchi  4096 Dec  8 14:39 Dir1
      drwxr-xr-x  3 koguchi  koguchi  4096 Dec  9 16:43 ..
      drwxr-xr-x  4 koguchi  koguchi  4096 Dec  9 16:43 .
    TEXT
    assert_equal expected, make_lists(['-alr'])
  end
end
