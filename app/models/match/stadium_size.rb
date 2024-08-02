class Match::StadiumSize
  attr_reader :totals_blend

  def initialize(totals_blend)
    @totals_blend = totals_blend
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @totals_blend.nil?

    club = Club.find_by(id: totals_blend.first[:team])
    stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

    attendance = if club.fanbase > stadium_size
                   (stadium_size * rand(0.9756..0.9923)).to_i
                 else
                   (club.fanbase * club.fan_happiness) / 100
                 end

    attendance
  end
end
