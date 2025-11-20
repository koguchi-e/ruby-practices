# frozen_string_literal: true

class Shot
  def transforme
    ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }
  end
end
