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
      pp "フレーム#{frame_score}"
      pp "ストライク+#{next_shot1}+#{next_shot2}"

      @total_score = frame_score + next_shot1 + next_shot2

      pp @total_score
    elsif spare?
      pp "フレーム#{frame_score}"
      pp "スペア+#{next_shot1}"

      @total_score = frame_score + next_shot1

      pp @total_score
    else
      pp "フレーム#{frame_score}"
      frame_score
    end
  end
end
