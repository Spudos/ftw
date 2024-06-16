class Turn::ClubUpdates
  attr_reader :week

  def initialize(week)
    @week = week
    @club_messages = []
  end

  def call
    clubs = Club.all
    clubs.each do |club|
      wage_bill(club)
      staff_costs(club)
      ground_upkeep(club)
      club_shop_income(club)
      fan_happiness_bank(club)
      fan_happiness_random(club)
    end

    match_day_income
    fan_happiness_match
    fan_happiness_signings
    overdrawn
    fix_overdraft

    Message.insert_all(@club_messages) unless @club_messages.empty?
  end

  private

  def wage_bill(club)
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

  def staff_costs(club)
    action_id = "#{week}#{club.id}upkeep"

    staff_costs_total = ((club.staff_gkp +
                          club.staff_dfc +
                          club.staff_mid +
                          club.staff_att +
                          club.staff_fitness +
                          club.staff_scouts)) * rand(9234..11234)

    new_bal = club.bank_bal.to_i - staff_costs_total.to_i
    club.update(bank_bal: new_bal)

    @club_messages << { action_id:,
                        week:,
                        club_id: club.id,
                        var1: "Your bank account was charged with #{staff_costs_total} due to this weeks staff wages",
                        var2: 'dec-staff_wages',
                        var3: staff_costs_total }
  end

  def ground_upkeep(club)
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

  def club_shop_income(club)
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

  def match_day_income
    home_games = Match.where(week_number: week).pluck(:home_team)

    home_games.each do |team|
      club = Club.find_by(id: team)
      action_id = "#{week}#{club.id}shop"
      stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

      if club.fanbase > stadium_size
        attendance = (stadium_size * rand(0.9756..0.9923)).to_i
      else
        attendance = (club.fanbase * club.fan_happiness) / 100
      end

      Match.find_by(week_number: week, home_team: team).update(attendance:)

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

  def fan_happiness_match
    match_info = Match.where(week_number: week)

    match_info.each do |match|
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
    signings = Transfer.where(week:, status: 'completed')

    signings.each do |signing|
      club = Club.find_by(id: signing.buy_club)
      club.fan_happiness = club.fan_happiness + 6
      club.save
    end
  end

  def fan_happiness_bank(club)
    if club.bank_bal > 80_000_000
      club.fan_happiness += 3
    elsif club.bank_bal < 20_000_000
      club.fan_happiness -= 5
    end
    club.save
  end

  def fan_happiness_random(club)
    club.fan_happiness = club.fan_happiness + rand(-3..3)
    if club.fan_happiness > 100
      club.fan_happiness = 100
    elsif club.fan_happiness.negative?
      club.fan_happiness = 0
    end
    club.save
  end

  def overdrawn
    clubs = Club.where.not(id: [241, 242]).where(managed: true)

    clubs.each do |club|
      if club.bank_bal.negative?
        club.overdrawn += 1
        club.save
        action_id = "#{week}#{club.id}OD"

        @club_messages << { action_id:,
                            week:,
                            club_id: club.id,
                            var1: 'Your club is overdrawn. If you do not fix the problems quickly the directors will step in and sell players to clear the debt' }
      end
    end
  end

  def fix_overdraft
    clubs = Club.where.not(id: [241, 242]).where(managed: true)

    clubs.each do |club|
      if club.overdrawn > 3 && club.bank_bal.negative?
        action_id = "#{week}#{club.id}OD"

        counter = 0

        while club.bank_bal.negative? && counter < 3
          player = Player.where(club_id: club.id).order(total_skill: :asc).first

          proceeds = (player.value * 0.75).to_i

          player.club_id = 242
          player.save

          club.bank_bal += proceeds
          club.save

          @club_messages << { action_id:,
                              week:,
                              club_id: club.id,
                              var1: "Your bank account was credited with #{proceeds} due a player sale (#{player.name})",
                              var2: 'inc-transfers_out',
                              var3: proceeds }

          Transfer.create(week:,
                          buy_club: 242,
                          sell_club: club.id,
                          player_id: player.id,
                          bid: proceeds,
                          status: 'completed')

          counter += 1
        end

        Article.create(week:,
                       club_id: club.id,
                       image: 'club.jpg',
                       article_type: 'Club',
                       headline: "#{club.name} Financial Crisis!",
                       sub_headline: "Players Sold to Clear Debts!",
                       article: 'Directors have taken over the financial affairs of the club after they were found to be overdrawn for three weeks.  Up to three players will be sold each week until the debt is cleared.  The club is in crisis and the fans are in uproar.  The board are considering looking for a new manager to take over the club and lead them to a brighter future although no change is imminent.')

        @club_messages << { action_id:,
                            week:,
                            club_id: club.id,
                            var1: 'Your club has been overdrawn for three weeks now and the directors have stepped in to rectify the problem.  Up to three players will be sold each week until the debt is cleared' }
      end

      if club.bank_bal.positive?
        club.overdrawn = 0
        club.save
      end
    end
  end
end
