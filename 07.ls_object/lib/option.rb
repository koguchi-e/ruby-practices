# frozen_string_literal: true

class Option
  def initialize
    parse_options
  end

  def show_all?
    @options.include?('-a')
  end

  def show_reverse?
    @options.include?('-r')
  end

  def show_long?
    @options.include?('-l')
  end

  private

  def parse_options
    @options = ARGV.flat_map do |argument|
      argument.start_with?('-') ? argument[1..].chars.map { |c| "-#{c}" } : argument
    end
  end
end
