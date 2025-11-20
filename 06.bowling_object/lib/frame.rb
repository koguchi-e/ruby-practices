# frozen_string_literal: true

class Frame
  def strike?
    @shot == 10
  end

  def spare?
    @shot + @next_shot1 == 10
  end

  def calculate_score(shots)
    index = 0

    point = 10.times.sum do
      @shot = shots[index]
      @next_shot1 = shots[index + 1]
      @next_shot2 = shots[index + 2]

      frame_score =
        if strike? || spare?
          @shot + @next_shot1 + @next_shot2
        else
          @shot + @next_shot1
        end
      index += (strike? ? 1 : 2)
      frame_score
    end
    puts point
    point
  end
end
