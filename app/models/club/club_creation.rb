class Club::ClubCreation
  attr_reader :club, :params

  def initialize(club, params)
    @club = club
    @params = params
  end

  def call
    set_club_in_user
    club_creation_details
    club_creation_stadium
    club_creation_departments
    club_creation_bank
    club_creation_fanbase
    player_removal

    if params[:club][:player_type] == 'junior'
      player_create_junior
    else
      player_create_senior
    end

    player_values

    Feedback.create(
      name: User.find_by(email: params[:club][:manager_email])&.fname,
      email: User.find_by(email: params[:club][:manager_email])&.email,
      club: club.id,
      message: 'A new club has been created',
      feedback_type: 'NewClub',
      outstanding: 'true'
    )

    Article.create(
      week: Message.maximum(:week),
      club_id: params[:club][:id],
      image: 'club.jpg',
      article_type: 'Club',
      headline: 'New Club Joins The League!',
      sub_headline: "#{params[:club][:name]} has joined the league",
      article: "#{params[:club][:name]} has joined the #{club.league} and are looking to make an impact. The board and fans are excited about the future."
    )

    Message.create(
      week: Message.maximum(:week),
      club_id: club.id,
      var1: "#{params[:club][:name]} has joined the league and will be managed by #{User.find_by(email: params[:club][:manager_email])&.fname} #{User.find_by(email: params[:club][:manager_email])&.lname}",
      var2: 'game',
      action_id: "#{params[:club][:name]}new"
    )
  end

  private

  def set_club_in_user
    User.find_by(email: params[:club][:manager_email]).update(club: club.id, appointed: Date.today)
  end

  def club_creation_details
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

  def club_creation_stadium
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
      random = 9500..10_000
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 7
      random = 10_750..11_250
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 8
      random = 12_000.12_500
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    when 9
      random = 13_250..13_750
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    else
      random = 14_500..15_000
      club.stand_n_capacity = rand(random)
      club.stand_e_capacity = rand(random)
      club.stand_s_capacity = rand(random)
      club.stand_w_capacity = rand(random)
    end
    club.save
  end

  def club_creation_departments
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

  def club_creation_bank
    club.bank_bal = params[:club][:bank_points].to_i * 100_000_000
    club.save
  end

  def club_creation_fanbase
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

  def player_removal
    club.players.each do |player|
      player.club_id = 242
      player.save
    end
  end

  def player_create_junior
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
        passing: rand(3..6),
        control: rand(3..6),
        tackling: rand(3..6),
        running: rand(2..5),
        shooting: rand(3..6),
        dribbling: rand(2..5),
        defensive_heading: rand(2..5),
        offensive_heading: rand(3..6),
        flair: rand(2..5),
        strength: rand(3..6),
        creativity: rand(2..5),
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
        available: 0,
        recovery: rand(0..15)
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(17..24),
        nationality: countries.sample,
        position: 'dfc',
        passing: rand(2..5),
        control: rand(3..6),
        tackling: rand(3..6),
        running: rand(3..6),
        shooting: rand(2..5),
        dribbling: rand(2..5),
        defensive_heading: rand(3..6),
        offensive_heading: rand(2..5),
        flair: rand(2..5),
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
        potential_tackling: rand(11..20),
        potential_running: rand(11..20),
        potential_shooting: rand(8..18),
        potential_dribbling: rand(8..18),
        potential_defensive_heading: rand(11..20),
        potential_offensive_heading: rand(8..18),
        potential_flair: rand(8..18),
        potential_strength: rand(11..20),
        potential_creativity: rand(11..20),
        available: 0,
        recovery: rand(0..15)
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(17..24),
        nationality: countries.sample,
        position: 'mid',
        passing: rand(3..6),
        control: rand(3..6),
        tackling: rand(2..5),
        running: rand(2..5),
        shooting: rand(3..6),
        dribbling: rand(3..6),
        defensive_heading: rand(2..5),
        offensive_heading: rand(2..5),
        flair: rand(3..6),
        strength: rand(2..5),
        creativity: rand(3..6),
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
        available: 0,
        recovery: rand(0..15)
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(17..24),
        nationality: countries.sample,
        position: 'att',
        passing: rand(2..5),
        control: rand(3..6),
        tackling: rand(2..5),
        running: rand(3..6),
        shooting: rand(3..6),
        dribbling: rand(3..6),
        defensive_heading: rand(2..5),
        offensive_heading: rand(3..6),
        flair: rand(3..6),
        strength: rand(2..5),
        creativity: rand(2..5),
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
        available: 0,
        recovery: rand(0..15)
      )
    end
  end

  def player_create_senior
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
        passing: rand(4..8),
        control: rand(4..8),
        tackling: rand(4..8),
        running: rand(4..6),
        shooting: rand(4..8),
        dribbling: rand(4..6),
        defensive_heading: rand(4..6),
        offensive_heading: rand(4..8),
        flair: rand(4..6),
        strength: rand(4..8),
        creativity: rand(4..6),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: 'p',
        potential_passing: rand(8..10),
        potential_control: rand(8..10),
        potential_tackling: rand(8..10),
        potential_running: rand(7..9),
        potential_shooting: rand(8..10),
        potential_dribbling: rand(7..9),
        potential_defensive_heading: rand(7..9),
        potential_offensive_heading: rand(8..10),
        potential_flair: rand(7..9),
        potential_strength: rand(8..10),
        potential_creativity: rand(7..9),
        available: 0
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(25..34),
        nationality: countries.sample,
        position: 'dfc',
        passing: rand(4..6),
        control: rand(4..8),
        tackling: rand(4..8),
        running: rand(4..8),
        shooting: rand(4..6),
        dribbling: rand(4..6),
        defensive_heading: rand(4..8),
        offensive_heading: rand(4..6),
        flair: rand(4..6),
        strength: rand(4..8),
        creativity: rand(4..8),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: position_detail.sample,
        potential_passing: rand(7..9),
        potential_control: rand(8..10),
        potential_tackling: rand(8..10),
        potential_running: rand(8..10),
        potential_shooting: rand(7..9),
        potential_dribbling: rand(7..9),
        potential_defensive_heading: rand(8..10),
        potential_offensive_heading: rand(7..9),
        potential_flair: rand(7..9),
        potential_strength: rand(8..10),
        potential_creativity: rand(8..10),
        available: 0
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(25..34),
        nationality: countries.sample,
        position: 'mid',
        passing: rand(4..8),
        control: rand(4..8),
        tackling: rand(4..6),
        running: rand(4..6),
        shooting: rand(4..8),
        dribbling: rand(4..8),
        defensive_heading: rand(4..6),
        offensive_heading: rand(4..6),
        flair: rand(4..8),
        strength: rand(4..6),
        creativity: rand(4..8),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: position_detail.sample,
        potential_passing: rand(8..10),
        potential_control: rand(8..10),
        potential_tackling: rand(7..9),
        potential_running: rand(7..9),
        potential_shooting: rand(8..10),
        potential_dribbling: rand(8..10),
        potential_defensive_heading: rand(7..9),
        potential_offensive_heading: rand(7..9),
        potential_flair: rand(8..10),
        potential_strength: rand(7..9),
        potential_creativity: rand(8..10),
        available: 0
      )
    end

    6.times do
      Player.create(
        name: Faker::Name.last_name,
        age: rand(25..34),
        nationality: countries.sample,
        position: 'att',
        passing: rand(4..6),
        control: rand(4..8),
        tackling: rand(4..6),
        running: rand(4..8),
        shooting: rand(4..8),
        dribbling: rand(4..8),
        defensive_heading: rand(4..6),
        offensive_heading: rand(4..8),
        flair: rand(4..8),
        strength: rand(4..6),
        creativity: rand(4..6),
        fitness: 100,
        contract: rand(13..46),
        club_id: club.id,
        consistency: rand(5..20),
        blend: rand(0..9),
        star: rand(5..30),
        loyalty: rand(10..50),
        player_position_detail: position_detail.sample,
        potential_passing: rand(7..9),
        potential_control: rand(8..10),
        potential_tackling: rand(7..9),
        potential_running: rand(8..10),
        potential_shooting: rand(8..10),
        potential_dribbling: rand(8..10),
        potential_defensive_heading: rand(7..9),
        potential_offensive_heading: rand(8..10),
        potential_flair: rand(8..10),
        potential_strength: rand(7..9),
        potential_creativity: rand(7..9),
        available: 0
      )
    end
  end

  def player_values
    players = Player.where(club_id: club.id)

    Player::Engines::ValueWages.new(players, 1).process

    players.each do |player|
      player.total_skill = player.total_skill_calc
      player.save
    end
  end
end
