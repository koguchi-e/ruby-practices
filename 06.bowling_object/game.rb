# frozen_string_literal: true

class Game

  def write(points)
    puts points.inspect
  end

  # point = 10.times.sum do
  #   shot = shots[index]
  #   next_shot1 = shots[index + 1]
  #   next_shot2 = shots[index + 2]

  #   strike = shot == 10
  #   spare = shot + next_shot1 == 10

  #   frame_score =
  #     shot + next_shot1 + (strike || spare ? next_shot2 : 0)

  #   index += (strike ? 1 : 2)

  #   frame_score
  # end

  # puts point
end
