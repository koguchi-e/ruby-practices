# frozen_string_literal: true

class CommandLineOption
  def initialize
    @option = ARGV.flat_map do |argument|
      argument.start_with?('-') ? argument[1..].chars.map { |c| "-#{c}" } : argument
    end
  end

  def show_all?
    @option.include?('-a')
  end

  def show_reverse?
    @option.include?('-r')
  end

  def show_long?
    @option.include?('-l')
  end
end
