class Turn::Engines::ClubFanHappinessBank
  attr_reader :week, :club

  def initialize(week, club)
    @week = week
    @club = club
  end

  def process
    if club.bank_bal > 80_000_000
      club.fan_happiness += 3
    elsif club.bank_bal < 20_000_000
      club.fan_happiness -= 5
    end
    club.save
  end
end
