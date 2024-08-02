class Club::Engines::ClubFanHappinessRandom
  attr_reader :week, :club

  def initialize(week, club)
    @week = week
    @club = club
  end

  def process
    club.fan_happiness = club.fan_happiness + rand(-3..3)
    if club.fan_happiness > 100
      club.fan_happiness = 100
    elsif club.fan_happiness < 10
      club.fan_happiness = rand(5..15)
    end
    club.save
  end
end
