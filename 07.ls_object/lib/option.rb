# frozen_string_literal: true

class Option
  def initialize
    parse_options
  end

  def parse_options
    @options = ARGV.flat_map do |argument|
      argument.start_with?('-') ? argument[1..].chars.map { |c| "-#{c}" } : argument
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

  def sort_entries
    load_entries
    @entries.sort_by!(&:downcase)
    reverse_entries
    @entries
  end

  private

  def load_entries
    @entries = if show_all?
                 Dir.entries('.')
               else
                 Dir['*']
               end
  end

  def reverse_entries
    @entries.reverse! if show_reverse?
  end
end
