class Match::StadiumEffect
  attr_reader :home_stadium_size, :totals_blend

  def initialize(totals_blend, home_stadium_size)
    @home_stadium_size = home_stadium_size
    @totals_blend = totals_blend
  end

  def call
    if home_stadium_size <= 10000
      stadium_effect = 0
    elsif home_stadium_size <= 20000
      stadium_effect = 2
    elsif home_stadium_size <= 30000
      stadium_effect = 5
    elsif home_stadium_size <= 40000
      stadium_effect = 8
    elsif home_stadium_size <= 50000
      stadium_effect = 10
    elsif home_stadium_size <= 60000
      stadium_effect = 12
    elsif home_stadium_size <= 70000
      stadium_effect = 15
    else
      stadium_effect = 20
    end

    totals_blend.first[:defense] += stadium_effect
    totals_blend.first[:midfield] += stadium_effect
    totals_blend.first[:attack] += stadium_effect

    totals_blend
  end
end
