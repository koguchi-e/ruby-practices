# frozen_string_literal: true

class Frame
  def initialize(shot1, shot2)
    @shot1 = shot1
    @shot2 = shot2
  end

  def strike?
    @shot1.score == 10
  end

  def spare?
    @shot1.score + @shot2.score == 10
  end

  def frame_score
    @shot1.score + @shot2.score
  end
end
