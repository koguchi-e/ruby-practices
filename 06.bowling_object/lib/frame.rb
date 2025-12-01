# frozen_string_literal: true

class Frame
  def initialize(*shots)
    @shots = shots
  end

  def strike?
    @shots.length == 1 && @shots[0].score == 10
  end

  def spare?
    @shots.length >= 2 && @shots[0].score + @shots[1].score == 10
  end

  def frame_score
    @shots.map(&:score).sum
  end

  def total_score(next_shot1, next_shot2)
    if strike?
      @total_score = frame_score + next_shot1 + next_shot2
    elsif spare?
      @total_score = frame_score + next_shot1
    else
      frame_score
    end
  end
end
