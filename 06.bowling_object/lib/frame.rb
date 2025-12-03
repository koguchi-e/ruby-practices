# frozen_string_literal: true

class Frame
  attr_reader :shots
  attr_accessor :next_frame

  def initialize(value)
    @shots = value.map { |v| Shot.new(v) }
  end

  def strike?
    @shots.length == 1 && @shots[0].hit_pins == 10
  end

  def spare?
    @shots.length >= 2 && @shots[0..1].map(&:hit_pins).sum == 10
  end

  def final_frame?
    next_frame.nil?
  end

  def score
    @shots.map(&:hit_pins).sum
  end

  def total_score
    return shots.sum(&:hit_pins) if final_frame?

    score +
      if strike?
        strike_bonus
      elsif spare?
        spare_bonus
      else
        0
      end
  end

  private

  def strike_bonus
    shots = []
    shots += next_frame.shots if next_frame
    shots += next_frame.next_frame.shots if next_frame&.next_frame
    shots.map(&:hit_pins).first(2).sum
  end

  def spare_bonus
    return 0 if next_frame.nil?

    next_frame.shots[0].hit_pins
  end
end
