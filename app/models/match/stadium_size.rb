class Match::StadiumSize
  attr_reader :totals_with_blend

  def initialize(totals_with_blend)
    @totals_with_blend = totals_with_blend
  end

  def call
    club = Club.find_by(abbreviation: totals_with_blend.first[:team])
    stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

    stadium_size
  end
end
