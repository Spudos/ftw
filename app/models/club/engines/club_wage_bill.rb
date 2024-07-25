class Club::Engines::ClubWageBill
  attr_reader :week, :club, :club_messages

  def initialize(week, club, club_messages)
    @week = week
    @club = club
    @club_messages = club_messages
  end

  def process
    action_id = "#{week}#{club.id}wage"

    wage_bill = Player.where(club_id: club.id).sum(:wages)

    new_bal = club.bank_bal.to_i - wage_bill.to_i
    club.update(bank_bal: new_bal)

    @club_messages << { action_id:,
                        week:,
                        club_id: club.id,
                        var1: "Your bank account was charged with #{wage_bill} due to this weeks player wages",
                        var2: 'dec-player_wages',
                        var3: wage_bill }
  end
end
