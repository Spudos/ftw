class Match::StadiumEffect
  attr_reader :home_stadium_size, :totals_with_blend

  def initialize(totals_with_blend, home_stadium_size)
    @home_stadium_size = home_stadium_size
    @totals_with_blend = totals_with_blend
  end

  def call
    if home_stadium_size <= 10000
      stadium_effect = 0
    elsif home_stadium_size <= 20000
      stadium_effect = 2
    elsif home_stadium_size <= 30000
      stadium_effect = 3
    elsif home_stadium_size <= 40000
      stadium_effect = 4
    elsif home_stadium_size <= 50000
      stadium_effect = 5
    elsif home_stadium_size <= 60000
      stadium_effect = 6
    elsif home_stadium_size <= 70000
      stadium_effect = 7
    else
      stadium_effect = 10
    end

    totals_with_blend.first[:defense] += stadium_effect
    totals_with_blend.first[:midfield] += stadium_effect
    totals_with_blend.first[:attack] += stadium_effect

    totals_with_blend
  end
end
