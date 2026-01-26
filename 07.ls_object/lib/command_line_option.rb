# frozen_string_literal: true

require 'optparse'

class CommandLineOption
  def initialize
    @show_all = false
    @show_reverse = false
    @show_long = false

    OptionParser.new do |opt|
      opt.on('-a') { @show_all = true }
      opt.on('-r') { @show_reverse = true }
      opt.on('-l') { @show_long = true }
    end.parse!(ARGV)
  end

  def show_all?
    @show_all
  end

  def show_reverse?
    @show_reverse
  end

  def show_long?
    @show_long
  end
end
