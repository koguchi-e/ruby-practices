# frozen_string_literal: true

class Frame
  def mapping(shots)
    shots.map { |s| s == 'X' ? 10 : s.to_i }
  end
  
  def calculate_index(shots)
    index = 0
    @shot = scores[index]
    @next_shot1 = scores[index + 1]
    @next_shot2 = scores[index + 2]
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

  def calculate_score(shots)
    if strike
      @shot + @next_shot1 + @next_shot2
    elsif spare
      @shot + @next_shot1 + @next_shot2
    else
      @shot + @next_shot1
    end
  end
end
