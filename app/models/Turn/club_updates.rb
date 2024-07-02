class Turn::ClubUpdates
  attr_reader :week

  def initialize(week)
    @week = week
    @club_messages = []
  end

  def call
    clubs = Club.all
    clubs.each do |club|
      Turn::Engines::ClubWageBill.new(week, club).process
      Turn::Engines::ClubStaffCosts.new(week, club).process
      Turn::Engines::ClubGroundUpkeep.new(week, club).process
      Turn::Engines::ClubShopIncome.new(week, club).process
      Turn::Engines::ClubFanHappinessBank.new(week, club).process
      Turn::Engines::ClubFanHappinessRandom.new(week, club).process
    end

    Turn::Engines::ClubMatchDayIncome.new(week).process
    Turn::Engines::ClubFanHappinessMatch.new(week).process
    Turn::Engines::ClubFanHappinessSignings.new(week).process
    Turn::Engines::ClubOverdrawn.new(week).process
    Turn::Engines::ClubFixOverdraft.new(week).process

    Message.insert_all(@club_messages) unless @club_messages.empty?
  end
end
