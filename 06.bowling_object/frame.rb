# frozen_string_literal: true

class Frame
  def mapping(shots)
    @frame = shots.map { |s| s == 'X' ? 10 : s.to_i }
    self
  end

  def strike?
    @shot == 10
  end

  def spare?
    @shot + @next_shot1 == 10
  end

  def bonus
    @next_shot1 + @next_shot2
  end

  def calculate_score
    index = 0

    10.times.sum do
      @shot = @frame[index]
      @next_shot1 = @frame[index + 1]
      @next_shot2 = @frame[index + 2]

      frame_score =
        if strike? || spare?
          @shot + @next_shot1 + @next_shot2
        else
          @shot + @next_shot1
        end

      index += (strike? ? 1 : 2)

      frame_score
    end
  end
end
