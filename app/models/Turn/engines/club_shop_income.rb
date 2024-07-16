class Turn::Engines::ClubShopIncome
  attr_reader :week, :club, :club_messages

  def initialize(week, club, club_messages)
    @week = week
    @club = club
    @club_messages = club_messages
  end

  def process
    action_id = "#{week}#{club.id}shop"

    club_shop_income = (club.fanbase * rand(1.07123..1.12123)).to_i

    new_bal = club.bank_bal.to_i + club_shop_income.to_i
    club.update(bank_bal: new_bal)

    @club_messages << { action_id:,
                        week:,
                        club_id: club.id,
                        var1: "Your bank account was credited with #{club_shop_income} due to this weeks club shop income",
                        var2: 'inc-club_shop_online',
                        var3: club_shop_income }
  end
end
