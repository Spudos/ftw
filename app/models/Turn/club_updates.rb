class Turn::ClubUpdates
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def call
    wage_bill
    staff_costs
    ground_upkeep
    club_shop_income
    match_day_income
    fan_happiness_match
    fan_happiness_signings
  end

  private

  def wage_bill
    clubs = Club.all
    clubs.each do |club|
      action_id = week.to_s + club.id.to_s + 'wage'

      wage_bill = Player.where(club_id: club.id).sum(:wages)

      new_bal = club.bank_bal.to_i - wage_bill.to_i
      club.update(bank_bal: new_bal)

      Message.create(action_id:, week:, club_id: club.id, var1: "Your bank account was charged with #{wage_bill} due to this weeks player wages", var2: 'dec-player_wages', var3: wage_bill)
    end
  end

  def staff_costs
    clubs = Club.all
    clubs.each do |club|
      action_id = week.to_s + club.id.to_s + 'upkeep'

      staff_costs_total = ((club.staff_gkp + club.staff_dfc + club.staff_mid + club.staff_att + club.staff_fitness + club.staff_scouts)) * rand(9234..11234)

      new_bal = club.bank_bal.to_i - staff_costs_total.to_i
      club.update(bank_bal: new_bal)

      Message.create(action_id:, week:, club_id: club.id, var1: "Your bank account was charged with #{staff_costs_total} due to this weeks staff wages", var2: 'dec-staff_wages', var3: staff_costs_total)
    end
  end

  def ground_upkeep
    clubs = Club.all
    clubs.each do |club|
      action_id = week.to_s + club.id.to_s + 'upkeep'

      stadium_cost = ((club.stand_n_capacity * club.stand_n_condition) + (club.stand_s_capacity * club.stand_s_condition) + (club.stand_e_capacity * club.stand_e_condition) + (club.stand_w_capacity * club.stand_w_condition)) * 6
      pitch_cost = club.pitch * rand(4545..5234)
      facilities_cost = club.facilities * rand(4545..5234)
      hospitality_cost = club.hospitality * rand(4545..5234)

      ground_upkeep_total = stadium_cost + pitch_cost + facilities_cost + hospitality_cost

      new_bal = club.bank_bal.to_i - ground_upkeep_total.to_i
      club.update(bank_bal: new_bal)

      Message.create(action_id:, week:, club_id: club.id, var1: "Your bank account was charged with #{ground_upkeep_total} due to this weeks stadium upkeep", var2: 'dec-stadium_upkeep', var3: ground_upkeep_total)
    end
  end

  def club_shop_income
    clubs = Club.all
    clubs.each do |club|
      action_id = week.to_s + club.id.to_s + 'shop'

      club_shop_income = (club.fanbase * rand(1.07123..1.12123)).to_i

      new_bal = club.bank_bal.to_i + club_shop_income.to_i
      club.update(bank_bal: new_bal)

      Message.create(action_id:, week:, club_id: club.id, var1: "Your bank account was credited with #{club_shop_income} due to this weeks club shop income", var2: 'inc-club_shop_online', var3: club_shop_income)
    end
  end

  def match_day_income
    home_games = Match.where(week_number: week).pluck(:home_team)

    home_games.each do |team|
      club = Club.find_by(id: team)
      action_id = week.to_s + club.id.to_s + 'shop'
      stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

      if club.fanbase > stadium_size
        attendance = (stadium_size * club.fan_happiness) / 100
      else
        attendance = (club.fanbase * club.fan_happiness) / 100
      end

      Match.find_by(week_number: week, home_team: team).update(attendance:)

      gate_receipts = attendance * club.ticket_price
      hospitality_receipts = club.hospitality * rand(102345..119234)
      facilities_receipts = club.facilities * rand(12345..19234)
      programme_receipts = (attendance * 1.2465).to_i
      club_shop_match_income = (attendance * 12.2465).to_i
      match_day_income = gate_receipts + facilities_receipts + programme_receipts + club_shop_match_income + hospitality_receipts

      policing_cost = (attendance * 3.5683).to_i
      stewarding_cost = (attendance * 2.3245).to_i
      medical_cost = (attendance * 0.4387).to_i
      match_day_costs = policing_cost + stewarding_cost + medical_cost

      net_match_day = match_day_income - match_day_costs

      new_bal = club.bank_bal.to_i + net_match_day
      club.update(bank_bal: new_bal)

      Message.create(action_id:, week:, club_id: club.id, var1: "You had a home match this week; This generated #{gate_receipts} in gate receipts", var2: 'inc-gate_receipts', var3: gate_receipts)
      Message.create(action_id:, week:, club_id: club.id, var1: "You had a home match this week; This generated #{hospitality_receipts} in hospitality receipts", var2: 'inc-hospitality', var3: hospitality_receipts)
      Message.create(action_id:, week:, club_id: club.id, var1: "You had a home match this week; This generated #{facilities_receipts} in facilities receipts", var2: 'inc-facilities', var3: facilities_receipts)
      Message.create(action_id:, week:, club_id: club.id, var1: "You had a home match this week; This generated #{programme_receipts} in programme receipts", var2: 'inc-programs', var3: programme_receipts)
      Message.create(action_id:, week:, club_id: club.id, var1: "You had a home match this week; This generated #{club_shop_match_income} in club shop receipts", var2: 'inc-club_shop_match', var3: club_shop_match_income)
      Message.create(action_id:, week:, club_id: club.id, var1: "You had a home match this week; This cost you #{policing_cost} in policing costs", var2: 'dec-policing', var3: policing_cost)
      Message.create(action_id:, week:, club_id: club.id, var1: "You had a home match this week; This cost you #{stewarding_cost} in stewarding costs", var2: 'dec-stewards', var3: stewarding_cost)
      Message.create(action_id:, week:, club_id: club.id, var1: "You had a home match this week; This cost you #{medical_cost} in medical costs", var2: 'dec-medical', var3: medical_cost)
    end
  end

  def fan_happiness_match
    match = Match.where(week_number: week)

    match.each do |match|
      home_team = Club.find_by(id: match.home_team)
      away_team = Club.find_by(id: match.away_team)

      if match.home_goals > match.away_goals
        home_team.fan_happiness = home_team.fan_happiness + 9
        away_team.fan_happiness = away_team.fan_happiness - 5
      elsif match.home_goals < match.away_goals
        home_team.fan_happiness = home_team.fan_happiness - 5
        away_team.fan_happiness = away_team.fan_happiness + 9
      else
        home_team.fan_happiness = home_team.fan_happiness + 3
        away_team.fan_happiness = away_team.fan_happiness + 3
      end
      home_team.save
      away_team.save
    end
  end

  def fan_happiness_signings
    signings = Transfer.where(week: week, status: 'completed')

    signings.each do |signing|
      club = Club.find_by(id: signing.buy_club)
      club.fan_happiness = club.fan_happiness + 6
      club.save
    end
  end

  def fan_happiness_bank
    clubs = Club.all

    clubs.each do |club|
      if club.bank_bal > 80000000
        club.fan_happiness += 3
      elsif club.bank_bal < 20000000
        club.fan_happiness -= 5
      end
      club.save
    end
  end

  def fan_happiness_random
    clubs = Club.all

    clubs.each do |club|
      club.fan_happiness = club.fan_happiness + rand(-3..3)
      if club.fan_happiness > 100
        club.fan_happiness = 100
      elsif club.fan_happiness < 0
        club.fan_happiness = 0
      end
      club.save
    end
  end
end