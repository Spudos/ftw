class Club < ApplicationRecord
  has_many :players

  def submission(params)
    club = Club.where(managed: false, league: params[:club][:league])&.first

    club_creation_details(club, params)
    club_creation_stadium(club, params)
    club_creation_departments(club, params)
    club_creation_bank(club, params)
    club_creation_fanbase(club, params)
    player_removal(club)

    if params[:club][:player_type] == 'junior'
      player_create_junior(club)
    else
      player_create_senior(club)
    end
  end

  def finance_items(club)
    highest_week_number = Message.maximum(:week)
    messages = Message.where(club_id: club, week: highest_week_number)

    total_income = 0
    total_expenditure = 0

    messages.each do |message|
      if message.var2.present? && message.var2.start_with?("inc")
        total_income += message.var3
      elsif message.var2.present?
        total_expenditure += message.var3
      end
    end

    items = {
      transfers_out: messages.where(var2: 'inc-transfers_out').sum(:var3),
      tv_income: messages.where(var2: 'inc-tv_income').sum(:var3),
      club_shop_online: messages.where(var2: 'inc-club_shop_online').sum(:var3),
      club_shop_match: messages.where(var2: 'inc-club_shop_match').sum(:var3),
      gate_receipts: messages.where(var2: 'inc-gate_receipts').sum(:var3),
      hospitality: messages.where(var2: 'inc-hospitality').sum(:var3),
      facilities: messages.where(var2: 'inc-facilities').sum(:var3),
      programs: messages.where(var2: 'inc-programs').sum(:var3),
      other: messages.where(var2: 'inc-other').sum(:var3),
      player_wages: messages.where(var2: 'dec-player_wages').sum(:var3),
      staff_wages: messages.where(var2: 'dec-staff_wages').sum(:var3),
      transfers_in: messages.where(var2: 'dec-transfers_in').sum(:var3),
      stadium_upkeep: messages.where(var2: 'dec-stadium_upkeep').sum(:var3),
      policing: messages.where(var2: 'dec-policing').sum(:var3),
      stewards: messages.where(var2: 'dec-stewards').sum(:var3),
      medical: messages.where(var2: 'dec-medical').sum(:var3),
      bonuses: messages.where(var2: 'dec-bonuses').sum(:var3),
      contracts: messages.where(var2: 'dec-contracts').sum(:var3),
      upgrades: messages.where(var2: 'dec-upgrades').sum(:var3),
      total_income:,
      total_expenditure:,
      week: highest_week_number
    }

    return items
  end

  private

  def club_creation_details(club, params)
    club.manager = params[:club][:manager]
    club.manager_email = params[:club][:manager_email]
    club.managed = true
    club.name = params[:club][:name]
    club.ground_name = params[:club][:ground_name]
    club.stand_n_name = params[:club][:stand_n_name]
    club.stand_e_name = params[:club][:stand_e_name]
    club.stand_s_name = params[:club][:stand_s_name]
    club.stand_w_name = params[:club][:stand_w_name]
    club.color_primary = params[:club][:color_primary]
    club.color_secondary = params[:club][:color_secondary]
    club.save
  end

  def club_creation_stadium(club, params)
    case params[:club][:stadium_points].to_i
    when 1
      random = 3250..3750
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 2
      random = 4500..5000
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 3
      random = 5750..6250
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 4
      random = 7000..7500
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 5
      random = 8250..8750
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 6
      random = 9500..10000
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 7
      random = 10750..11250
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 8
      random = 12000.12500
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 9
      random = 13250..13750
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    else
      random = 14500..15000
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    end
    club.save
  end

  def club_creation_departments(club, params)
    case params[:club][:stadium_points].to_i
    when 1..3
      club.stand_n_condition = rand(2..4)
      club.stand_e_condition = rand(2..4)
      club.stand_s_condition = rand(2..4)
      club.stand_w_condition = rand(2..4)
      club.pitch = rand(2..4)
      club.facilities = rand(2..4)
      club.hospitality = rand(2..4)
      club.staff_fitness = rand(2..4)
      club.staff_gkp = rand(2..4)
      club.staff_dfc = rand(2..4)
      club.staff_mid = rand(2..4)
      club.staff_att = rand(2..4)
      club.staff_scouts = rand(2..4)
    when 4..6
      club.stand_n_condition = rand(5..8)
      club.stand_e_condition = rand(5..8)
      club.stand_s_condition = rand(5..8)
      club.stand_w_condition = rand(5..8)
      club.pitch = rand(5..8)
      club.facilities = rand(5..8)
      club.hospitality = rand(5..8)
      club.staff_fitness = rand(5..8)
      club.staff_gkp = rand(5..8)
      club.staff_dfc = rand(5..8)
      club.staff_mid = rand(5..8)
      club.staff_att = rand(5..8)
      club.staff_scouts = rand(5..8)
    else
      club.stand_n_condition = rand(9..12)
      club.stand_e_condition = rand(9..12)
      club.stand_s_condition = rand(9..12)
      club.stand_w_condition = rand(9..12)
      club.pitch = rand(9..12)
      club.facilities = rand(9..12)
      club.hospitality = rand(9..12)
      club.staff_fitness = rand(9..12)
      club.staff_gkp = rand(9..12)
      club.staff_dfc = rand(9..12)
      club.staff_mid = rand(9..12)
      club.staff_att = rand(9..12)
      club.staff_scouts = rand(9..12)
    end
    club.save
  end

  def club_creation_bank(club, params)
    club.bank_bal = params[:club][:bank_points].to_i * 100_000_000
    club.save
  end

  def club_creation_fanbase(club, params)
    case params[:club][:fanbase_points].to_i
    when 1
      club.fanbase = 30_000
    when 2
      club.fanbase = 40_000
    when 3
      club.fanbase = 50_000
    when 4
      club.fanbase = 60_000
    when 5
      club.fanbase = 70_000
    when 6
      club.fanbase = 80_000
    when 7
      club.fanbase = 90_000
    when 8
      club.fanbase = 100_000
    when 9
      club.fanbase = 110_000
    else
      club.fanbase = 120_000
    end
    club.save
  end

  def player_removal(club)
    club.players.each do |player|
      player.club_id = 242
      player.save
    end
  end

  def player_create_junior(club)
    countries = ['England', 'England', 'England', 'England', 'Scotland', 'Wales',
                 'NI', 'RoI', 'Brazil', 'Argentina', 'Spain', 'France', 'Germany',
                 'Poland', 'Portugal', 'USA', 'Belgium', 'Mexico', 'Uruguay','Brazil',
                 'England', 'Mexico', 'Germany', 'Italy', 'Spain', 'France', 'Argentina',
                 'Netherlands', 'Portugal', 'Belgium', 'Uruguay', 'Colombia', 'Croatia',
                 'Sweden', 'Switzerland', 'Poland', 'Denmark', 'Chile', 'Austria',
                 'Turkey', 'Russia', 'Japan', 'South Korea', 'Australia']

    position_detail = ['c', 'c', 'c', 'l', 'r']

    3.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(17..24),
        nationality: countries.sample,
        position: 'gkp',
        passing: rand(4..7),
        control: rand(4..7),
        tackling: rand(4..7),
        running: rand(3..6),
        shooting: rand(4..7),
        dribbling: rand(3..6),
        defensive_heading: rand(3..6),
        offensive_heading: rand(4..7),
        flair: rand(3..6),
        strength: rand(4..7),
        creativity: rand(3..6),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: 'p',
        potential_passing: rand(11..20),
        potential_control: rand(11..20),
        potential_tackling: rand(11..20),
        potential_running: rand(8..18),
        potential_shooting: rand(11..20),
        potential_dribbling: rand(8..18),
        potential_defensive_heading: rand(8..18),
        potential_offensive_heading: rand(11..20),
        potential_flair: rand(8..18),
        potential_strength: rand(11..20),
        potential_creativity: rand(8..18),
        available: 0
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(17..24),
        nationality: countries.sample,
        position: 'dfc',
        passing: rand(3..6),
        control: rand(4..7),
        tackling: rand(4..7),
        running: rand(4..7),
        shooting: rand(3..6),
        dribbling: rand(3..6),
        defensive_heading: rand(4..7),
        offensive_heading: rand(3..6),
        flair: rand(3..6),
        strength: rand(4..7),
        creativity: rand(4..7),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: position_detail.sample,
        potential_passing: rand(8..18),
        potential_control: rand(11..20),
        potential_tackling: rand(11..20),
        potential_running: rand(11..20),
        potential_shooting: rand(8..18),
        potential_dribbling: rand(8..18),
        potential_defensive_heading: rand(11..20),
        potential_offensive_heading: rand(8..18),
        potential_flair: rand(8..18),
        potential_strength: rand(11..20),
        potential_creativity: rand(11..20),
        available: 0
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(17..24),
        nationality: countries.sample,
        position: 'mid',
        passing: rand(4..7),
        control: rand(4..7),
        tackling: rand(3..6),
        running: rand(3..6),
        shooting: rand(4..7),
        dribbling: rand(4..7),
        defensive_heading: rand(3..6),
        offensive_heading: rand(3..6),
        flair: rand(4..7),
        strength: rand(3..6),
        creativity: rand(4..7),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: position_detail.sample,
        potential_passing: rand(11..20),
        potential_control: rand(11..20),
        potential_tackling: rand(8..18),
        potential_running: rand(8..18),
        potential_shooting: rand(11..20),
        potential_dribbling: rand(11..20),
        potential_defensive_heading: rand(8..18),
        potential_offensive_heading: rand(8..18),
        potential_flair: rand(11..20),
        potential_strength: rand(8..18),
        potential_creativity: rand(11..20),
        available: 0
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(17..24),
        nationality: countries.sample,
        position: 'att',
        passing: rand(3..6),
        control: rand(4..7),
        tackling: rand(3..6),
        running: rand(4..7),
        shooting: rand(4..7),
        dribbling: rand(4..7),
        defensive_heading: rand(3..6),
        offensive_heading: rand(4..7),
        flair: rand(4..7),
        strength: rand(3..6),
        creativity: rand(3..6),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: position_detail.sample,
        potential_passing: rand(8..18),
        potential_control: rand(11..20),
        potential_tackling: rand(8..18),
        potential_running: rand(11..20),
        potential_shooting: rand(11..20),
        potential_dribbling: rand(11..20),
        potential_defensive_heading: rand(8..18),
        potential_offensive_heading: rand(11..20),
        potential_flair: rand(11..20),
        potential_strength: rand(8..18),
        potential_creativity: rand(8..18),
        available: 0
      )
    end
  end

  def player_create_senior(club)
    countries = ['England', 'England', 'England', 'England', 'Scotland', 'Wales',
                 'NI', 'RoI', 'Brazil', 'Argentina', 'Spain', 'France', 'Germany',
                 'Poland', 'Portugal', 'USA', 'Belgium', 'Mexico', 'Uruguay','Brazil',
                 'England', 'Mexico', 'Germany', 'Italy', 'Spain', 'France', 'Argentina',
                 'Netherlands', 'Portugal', 'Belgium', 'Uruguay', 'Colombia', 'Croatia',
                 'Sweden', 'Switzerland', 'Poland', 'Denmark', 'Chile', 'Austria',
                 'Turkey', 'Russia', 'Japan', 'South Korea', 'Australia']

    position_detail = ['c', 'c', 'c', 'l', 'r']

    3.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(25..34),
        nationality: countries.sample,
        position: 'gkp',
        passing: rand(5..9),
        control: rand(5..9),
        tackling: rand(5..9),
        running: rand(5..7),
        shooting: rand(5..9),
        dribbling: rand(5..7),
        defensive_heading: rand(5..7),
        offensive_heading: rand(5..9),
        flair: rand(5..7),
        strength: rand(5..9),
        creativity: rand(5..7),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: 'p',
        potential_passing: rand(9..11),
        potential_control: rand(9..11),
        potential_tackling: rand(9..11),
        potential_running: rand(8..10),
        potential_shooting: rand(9..11),
        potential_dribbling: rand(8..10),
        potential_defensive_heading: rand(8..10),
        potential_offensive_heading: rand(9..11),
        potential_flair: rand(8..10),
        potential_strength: rand(9..11),
        potential_creativity: rand(8..10),
        available: 0
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(25..34),
        nationality: countries.sample,
        position: 'dfc',
        passing: rand(5..7),
        control: rand(5..9),
        tackling: rand(5..9),
        running: rand(5..9),
        shooting: rand(5..7),
        dribbling: rand(5..7),
        defensive_heading: rand(5..9),
        offensive_heading: rand(5..7),
        flair: rand(5..7),
        strength: rand(5..9),
        creativity: rand(5..9),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: position_detail.sample,
        potential_passing: rand(8..10),
        potential_control: rand(9..11),
        potential_tackling: rand(9..11),
        potential_running: rand(9..11),
        potential_shooting: rand(8..10),
        potential_dribbling: rand(8..10),
        potential_defensive_heading: rand(9..11),
        potential_offensive_heading: rand(8..10),
        potential_flair: rand(8..10),
        potential_strength: rand(9..11),
        potential_creativity: rand(9..11),
        available: 0
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(25..34),
        nationality: countries.sample,
        position: 'mid',
        passing: rand(5..9),
        control: rand(5..9),
        tackling: rand(5..7),
        running: rand(5..7),
        shooting: rand(5..9),
        dribbling: rand(5..9),
        defensive_heading: rand(5..7),
        offensive_heading: rand(5..7),
        flair: rand(5..9),
        strength: rand(5..7),
        creativity: rand(5..9),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: position_detail.sample,
        potential_passing: rand(9..11),
        potential_control: rand(9..11),
        potential_tackling: rand(8..10),
        potential_running: rand(8..10),
        potential_shooting: rand(9..11),
        potential_dribbling: rand(9..11),
        potential_defensive_heading: rand(8..10),
        potential_offensive_heading: rand(8..10),
        potential_flair: rand(9..11),
        potential_strength: rand(8..10),
        potential_creativity: rand(9..11),
        available: 0
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(25..34),
        nationality: countries.sample,
        position: 'att',
        passing: rand(5..7),
        control: rand(5..9),
        tackling: rand(5..7),
        running: rand(5..9),
        shooting: rand(5..9),
        dribbling: rand(5..9),
        defensive_heading: rand(5..7),
        offensive_heading: rand(5..9),
        flair: rand(5..9),
        strength: rand(5..7),
        creativity: rand(5..7),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: position_detail.sample,
        potential_passing: rand(8..10),
        potential_control: rand(9..11),
        potential_tackling: rand(8..10),
        potential_running: rand(9..11),
        potential_shooting: rand(9..11),
        potential_dribbling: rand(9..11),
        potential_defensive_heading: rand(8..10),
        potential_offensive_heading: rand(9..11),
        potential_flair: rand(9..11),
        potential_strength: rand(8..10),
        potential_creativity: rand(8..10),
        available: 0
      )
    end
  end
end
