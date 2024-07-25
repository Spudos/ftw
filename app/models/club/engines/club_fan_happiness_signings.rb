class Club::Engines::ClubFanHappinessSignings
  attr_reader :week

  def initialize(week)
    @week = week
    @club_messages = []
  end

  def process
    signings = Transfer.where(week:, status: 'completed')

    signings.each do |signing|
      club = Club.find_by(id: signing.buy_club)
      club.fan_happiness = club.fan_happiness + 6
      club.save
    end
  end
end
