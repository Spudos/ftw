class Turn::Engines::ClubFanHappinessRandom
  attr_reader :week, :club

  def initialize(week, club)
    @week = week
    @club = club
    @club_messages = []
  end

  def process
    club.fan_happiness = club.fan_happiness + rand(-3..3)
    if club.fan_happiness > 100
      club.fan_happiness = 100
    elsif club.fan_happiness.negative?
      club.fan_happiness = 0
    end
    club.save
  end
end
