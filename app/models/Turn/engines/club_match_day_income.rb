class Turn::Engines::ClubMatchDayIncome
  attr_reader :week, :gate_receipts, :hospitality_receipts,
              :facilities_receipts, :programme_receipts, :club_shop_match_income, :tv_income,
              :policing_cost, :stewarding_cost, :medical_cost, :action_id, :club

  def initialize(week)
    @week = week
    @club_messages = []
  end

  def process
    calculate_match_game_income
  end

  private

  def calculate_match_game_income
    home_games.each do |team, attendance|
      club = clubs.find { |current_club| current_club.id == team.to_i }

      next if club.nil?

      @action_id = "#{week}#{club.id}shop"
      @gate_receipts = attendance * club.ticket_price
      @hospitality_receipts = club.hospitality * rand(102_345..119_234)
      @facilities_receipts = club.facilities * rand(12_345..19_234)
      @programme_receipts = (attendance * 10.2465).to_i
      @club_shop_match_income = (attendance * 15.2465).to_i
      @tv_income = (attendance * 29.3456).to_i
      match_day_income = gate_receipts +
                         facilities_receipts +
                         programme_receipts +
                         club_shop_match_income +
                         hospitality_receipts +
                         tv_income

      @policing_cost = (attendance * 3.5683).to_i
      @stewarding_cost = (attendance * 2.3245).to_i
      @medical_cost = (attendance * 0.4387).to_i
      match_day_costs = policing_cost + stewarding_cost + medical_cost

      net_match_day = match_day_income - match_day_costs

      new_bal = club.bank_bal.to_i + net_match_day
      club.update(bank_bal: new_bal)

      messaging(club.id)
    end
  end

  def messaging(club_id)
    message_types = [['gate receipts', gate_receipts, 'inc-gate_receipts', 'received'],
                     ['hospitality income', hospitality_receipts, 'inc-hospitality', 'received'],
                     ['facilities income', facilities_receipts, 'inc-facilities', 'received'],
                     ['programme sales', programme_receipts, 'inc-programs', 'received'],
                     ['club shop match day', club_shop_match_income, 'inc-club_shop_match', 'received'],
                     ['TV revenue', tv_income, 'inc-tv_income', 'received'],
                     ['policing costs', policing_cost, 'dec-policing', 'paid'],
                     ['stewarding costs', stewarding_cost, 'dec-stewards', 'paid'],
                     ['medical costs', medical_cost, 'dec-medical', 'paid']]

    message_types.each do |category, value, var2, type|
      @club_messages << {
        action_id:,
        week:,
        club_id:,
        var1: "Due to your home game this week, you #{type} #{value} in #{category}",
        var2:,
        var3: value
      }
    end
  end

  def clubs
    @clubs = Club.where(id: home_games)
  end

  def home_games
    @home_games = Match.where(week_number: week).pluck(:home_team, :attendance)
  end
end
