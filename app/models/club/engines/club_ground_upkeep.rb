class Club::Engines::ClubGroundUpkeep
  attr_reader :week, :club, :club_messages

  def initialize(week, club, club_messages)
    @week = week
    @club = club
    @club_messages = club_messages
  end

  def process
    action_id = "#{week}#{club.id}upkeep"

    stadium_cost = ((club.stand_n_capacity * club.stand_n_condition) +
                    (club.stand_s_capacity * club.stand_s_condition) +
                    (club.stand_e_capacity * club.stand_e_condition) +
                    (club.stand_w_capacity * club.stand_w_condition)) * 3
    pitch_cost = club.pitch * rand(1845..2434)
    facilities_cost = club.facilities * rand(1845..2434)
    hospitality_cost = club.hospitality * rand(1845..2434)

    ground_upkeep_total = stadium_cost + pitch_cost + facilities_cost + hospitality_cost

    new_bal = club.bank_bal.to_i - ground_upkeep_total.to_i
    club.update(bank_bal: new_bal)

    @club_messages << { action_id:,
                        week:,
                        club_id: club.id,
                        var1: "Your bank account was charged with #{ground_upkeep_total} due to this weeks stadium upkeep",
                        var2: 'dec-stadium_upkeep',
                        var3: ground_upkeep_total }
  end
end
