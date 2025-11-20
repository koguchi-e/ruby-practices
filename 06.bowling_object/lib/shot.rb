# frozen_string_literal: true

class Shot
  def read
    shots = ARGV[0].split(',')
  end
  def mapping(shots)
    shots.map { |s| s == 'X' ? 10 : s.to_i }
  end
end
