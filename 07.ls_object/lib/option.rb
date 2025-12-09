# frozen_string_literal: true

class Option
  def initialize
    parse_options
  end

  def parse_options
    @options = ARGV.flat_map do |argument|
      argument.start_with?('-') ? argument[1..].chars.map { |c| "-#{c}" } : argument
    end

    if show_all?
      @show_all = @options.include?('-a')
    end

    if show_reverse?
      @show_reverse = @options.include?('-r')
    end

    if show_list?
      @show_list = @options.include?('-l')
    end
  end

  def show_all?
    @options.include?('-a')
  end

  def show_reverse?
    @options.include?('-r')
  end

  def show_list?
    @options.include?('-l')
  end

  def load_entries
    if @show_all
      @entries = Dir.entries('.')
      sort_entries
    else
      @entries = Dir['*']
      sort_entries
      reverse_entries
    end
    @entries
  end

  def sort_entries
    @entries.sort_by!(&:downcase)
  end

  def reverse_entries
    @entries.reverse! if @show_reverse
  end
end
