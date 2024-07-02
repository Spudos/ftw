class Turn::Engines::ClubMatchDayIncome
  attr_reader :week

  def initialize(week) # pass messages
    @week = week
    @club_messages = []
  end

  def process
    update_matches
    calculate_match_game_income
  end

  private

  def calculate_match_game_income
    home_games.each do |team, attendance|
      club = clubs.find { |current_club| current_club.id == team.to_i }

      next if club.nil?

      action_id = "#{week}#{club.id}shop"

      gate_receipts = attendance * club.ticket_price
      hospitality_receipts = club.hospitality * rand(102_345..119_234)
      facilities_receipts = club.facilities * rand(12_345..19_234)
      programme_receipts = (attendance * 10.2465).to_i
      club_shop_match_income = (attendance * 15.2465).to_i
      tv_income = (attendance * 29.3456).to_i
      match_day_income = gate_receipts +
                          facilities_receipts +
                          programme_receipts +
                          club_shop_match_income +
                          hospitality_receipts +
                          tv_income

      policing_cost = (attendance * 3.5683).to_i
      stewarding_cost = (attendance * 2.3245).to_i
      medical_cost = (attendance * 0.4387).to_i
      match_day_costs = policing_cost + stewarding_cost + medical_cost

      net_match_day = match_day_income - match_day_costs

      new_bal = club.bank_bal.to_i + net_match_day
      club.update(bank_bal: new_bal)

      # @messages.add({ action_id:, week:, club_id:, var1: var1_message(gate_receipts, 'gate') })
      @club_messages << { action_id:, week:, club_id: club.id,
                          var1: "You had a home match this week; This generated #{gate_receipts} in gate receipts",
                          var2: 'inc-gate_receipts', var3: gate_receipts }
      @club_messages << { action_id:, week:, club_id: club.id,
                          var1: "You had a home match this week; This generated #{hospitality_receipts} in hospitality receipts",
                          var2: 'inc-hospitality', var3: hospitality_receipts }
      @club_messages << { action_id:, week:, club_id: club.id,
                          var1: "You had a home match this week; This generated #{facilities_receipts} in facilities receipts",
                          var2: 'inc-facilities', var3: facilities_receipts }
      @club_messages << { action_id:, week:, club_id: club.id,
                          var1: "You had a home match this week; This generated #{programme_receipts} in programme receipts",
                          var2: 'inc-programs', var3: programme_receipts }
      @club_messages << { action_id:, week:, club_id: club.id,
                          var1: "You had a home match this week; This generated #{club_shop_match_income} in club shop receipts",
                          var2: 'inc-club_shop_match', var3: club_shop_match_income }
      @club_messages << { action_id:, week:, club_id: club.id,
                          var1: "You had a home match this week; This generated #{tv_income} in world wide entertainment and TV rights",
                          var2: 'inc-tv_income', var3: tv_income }
      @club_messages << { action_id:, week:, club_id: club.id,
                          var1: "You had a home match this week; This cost you #{policing_cost} in policing costs",
                          var2: 'dec-policing', var3: policing_cost }
      @club_messages << { action_id:, week:, club_id: club.id,
                          var1: "You had a home match this week; This cost you #{stewarding_cost} in stewarding costs",
                          var2: 'dec-stewards', var3: stewarding_cost }
      @club_messages << { action_id:, week:, club_id: club.id,
                          var1: "You had a home match this week; This cost you #{medical_cost} in medical costs",
                          var2: 'dec-medical', var3: medical_cost }
    end
  end

  def var1_message(value, type)
    "You had a home match this week; This cost you #{value} in #{type} costs"
  end

  def clubs
    @clubs = Club.where(id: home_games)
  end

  def home_games
    @home_games = Match.where(week_number: week).pluck(:home_team, :attendance)
  end

  def update_matches
    all_matches = Match.where(week_number: week).where(home_team: attendances.keys)
    all_matches.each do |match|
      match.attendance = attendances[match.home_team.to_i]
    end
    Match.upsert_all(all_matches.as_json) if all_matches.present?
  end

  def attendances
    @attendances ||= {}.tap do |match_attendance|
      clubs.each do |club|
        match_attendance[club.id] = Turn::MatchAttendanceCalculator.new(club).process
      end
    end
  end
end
