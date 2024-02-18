class Match::StadiumSize
  attr_reader :totals_blend

  def initialize(totals_blend)
    @totals_blend = totals_blend
  end

  def call
    if @totals_blend.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    club = Club.find_by(id: totals_blend.first[:team])
    stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

    stadium_size
  end
end
