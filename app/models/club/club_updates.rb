class Club::ClubUpdates
  attr_reader :week

  def initialize(week)
    @week = week
    @club_messages = []
  end

  def call
    clubs = Club.all
    clubs.each do |club|
      Club::Engines::ClubWageBill.new(week, club, @club_messages).process
      Club::Engines::ClubStaffCosts.new(week, club, @club_messages).process
      Club::Engines::ClubGroundUpkeep.new(week, club, @club_messages).process
      Club::Engines::ClubShopIncome.new(week, club, @club_messages).process
      Club::Engines::ClubFanHappinessBank.new(week, club).process
      Club::Engines::ClubFanHappinessRandom.new(week, club).process
    end

    message_type_resolver = Club::Engines::MessageTypeResolver.new(@club_messages)

    Club::Engines::CalculateAttendances.new(week).process
    Club::Engines::ClubMatchDayIncome.new(week, message_type_resolver).process
    Club::Engines::ClubFanHappinessMatch.new(week).process
    Club::Engines::ClubFanHappinessSignings.new(week).process
    Club::Engines::ClubOverdrawn.new(week).process
    Club::Engines::ClubFixOverdraft.new(week).process

    Message.insert_all(@club_messages) unless @club_messages.empty? # check
  end
end
