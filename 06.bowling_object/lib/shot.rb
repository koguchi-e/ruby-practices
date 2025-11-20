# frozen_string_literal: true

class Shot
  def transforme
    read.map { |s| s == 'X' ? 10 : s.to_i }
  end

  private

  def read
    ARGV[0].split(',')
  end
end
