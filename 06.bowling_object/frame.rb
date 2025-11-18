# frozen_string_literal: true

class Frame
  def mapping(shots)
    shots.map { |s| s == 'X' ? 10 : s.to_i }
  end
end
