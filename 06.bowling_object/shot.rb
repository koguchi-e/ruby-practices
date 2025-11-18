# frozen_string_literal: true

class Shot
  def read
    score = ARGV[0]
    score.split(',')
  end
end
