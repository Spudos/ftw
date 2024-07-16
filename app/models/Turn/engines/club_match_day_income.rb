class Turn::Engines::ClubMatchDayIncome
  attr_reader :week, :gate_receipts, :hospitality_receipts,
              :facilities_receipts, :programme_receipts, :club_shop_match_income, :tv_income,
              :policing_cost, :stewarding_cost, :medical_cost, :action_id, :club

  def initialize(week, message_type_resolver)
    @week = week
    @message_type_resolver = message_type_resolver
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

      net_match_day = match_day_income(club, attendance) - match_day_costs(attendance)

      new_bal = club.bank_bal.to_i + net_match_day
      club.update(bank_bal: new_bal)

      @message_type_resolver.message(club.id, action_id, week, expenses)
    end
  end

  def match_day_income(club, attendance)
    @gate_receipts = attendance * club.ticket_price
    @hospitality_receipts = club.hospitality * rand(102_345..119_234)
    @facilities_receipts = club.facilities * rand(12_345..19_234)
    @programme_receipts = (attendance * 10.2465).to_i
    @club_shop_match_income = (attendance * 15.2465).to_i
    @tv_income = (attendance * 29.3456).to_i
    gate_receipts + facilities_receipts + programme_receipts +
      club_shop_match_income + hospitality_receipts + tv_income
  end

  def match_day_costs(attendance)
    @policing_cost = (attendance * 3.5683).to_i
    @stewarding_cost = (attendance * 2.3245).to_i
    @medical_cost = (attendance * 0.4387).to_i
    policing_cost + stewarding_cost + medical_cost
  end

  def expenses
    {
      gate_receipts:,
      hospitality_receipts:,
      facilities_receipts:,
      programme_receipts:,
      club_shop_match_income:,
      tv_income:,
      policing_cost:,
      stewarding_cost:,
      medical_cost:
    }
  end

  def clubs
    @clubs = Club.where(id: home_games.flatten.compact)
  end

  def home_games
    @home_games = Match.where(week_number: week).pluck(:home_team, :attendance)
  end
end
