class Turn::MatchAttendanceCalculator
  attr_reader :club

  def initialize(club)
    @club = club
  end

  def process
    stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

    if club.fanbase > stadium_size
      attendance = (stadium_size * rand(0.9756..0.9923)).to_i
    else
      attendance = (club.fanbase * club.fan_happiness) / 100
    end

    attendance
  end
end
