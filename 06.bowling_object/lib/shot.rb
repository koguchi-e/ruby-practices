# frozen_string_literal: true

class Shot
  def initialize(shot)
    @shot = shot
  end

  def score
    if @shot == 'X'
      return 10
    else
      @shot.to_i
    end
  end
end
