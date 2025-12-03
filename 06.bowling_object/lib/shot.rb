# frozen_string_literal: true

class Shot
  def initialize(shot)
    @shot = shot
  end

  def hit_pins
    return 10 if @shot == 'X'

    @shot.to_i
  end
end
