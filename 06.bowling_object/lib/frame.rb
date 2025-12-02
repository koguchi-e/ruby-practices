# frozen_string_literal: true

class Frame
  attr_reader :shots
  attr_accessor :next_frame

  def initialize(value)
    @shots = value.map { |v| Shot.new(v) }
  end

  def strike?
    @shots.length == 1 && @shots[0].score == 10
  end

  def spare?
    @shots.length >= 2 && @shots[0..1].map(&:score).sum == 10
  end

  def strike_bonus
    shots = []
    shots += next_frame.shots if next_frame
    shots += next_frame.next_frame.shots if next_frame&.next_frame
    shots.map(&:score).first(2).sum
  end

  def spare_bonus
    return 0 if next_frame.nil?

    next_frame.shots[0].score
  end

  def final_frame?
    next_frame.nil?
  end

  def frame_score
    @shots.map(&:score).sum
  end

  def total_score
    return shots.sum(&:score) if final_frame?

    if strike?
      @total_score = 10 + strike_bonus
    elsif spare?
      @total_score = 10 + spare_bonus
    else
      frame_score
    end
  end
end
