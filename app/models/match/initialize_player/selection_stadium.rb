class Match::InitializePlayer::SelectionStadium
  attr_reader :selection_star, :fixture_list

  def initialize(selection_star, fixture_list)
    @selection_star = selection_star
    @fixture_list = fixture_list
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @selection_star.nil?

    fixture_list_with_attendance = []
    selection_stadium = []

    home_teams = fixture_list.map { |fixture| fixture[:club_home] }
    home_team_attributes = stands_and_fans(home_teams)

    fixture_list.each do |fixture|
      attributes = home_team_attributes.find { |hash| hash[:club_id] == fixture[:club_home].to_i }

      fixture[:attendance] = calulate_attendance(attributes)

      fixture_list_with_attendance << fixture
    end

    selection_star.each do |player|
      player_adjustment = stadium_effect(fixture_list_with_attendance, player)

      player[:performance] = player[:performance] + player_adjustment

      selection_stadium << player
    end

    return selection_stadium, fixture_list_with_attendance
  end

  private

  def stands_and_fans(home_teams)
    home_team_attributes = []

    home_teams.each do |club|
      club = Club.find_by(id: club.to_i)

      hash = club_attributes(club)

      home_team_attributes << hash
    end

    home_team_attributes
  end

  def club_attributes(club)
    { club_id: club.id,
      stand_n_capacity: club.stand_n_capacity,
      stand_s_capacity: club.stand_s_capacity,
      stand_e_capacity: club.stand_e_capacity,
      stand_w_capacity: club.stand_w_capacity,
      fan_happiness: club.fan_happiness,
      fanbase: club.fanbase }
  end

  def calulate_attendance(attributes)
    stadium_size = attributes[:stand_n_capacity] +
                   attributes[:stand_s_capacity] +
                   attributes[:stand_e_capacity] +
                   attributes[:stand_w_capacity]

    if attributes[:fanbase] > stadium_size
      (stadium_size * rand(0.9756..0.9923)).to_i
    else
      (attributes[:fanbase] * attributes[:fan_happiness]) / 100
    end
  end

  def stadium_effect(fixture_list_with_attendance, player)
    fixture_record = fixture_list_with_attendance.find { |hash| hash[:club_home] == player[:club_id] }

    if fixture_record.present?
      attendance_effect(fixture_record[:attendance])
    else
      0
    end
  end

  def attendance_effect(attendance)
    attendance_ranges = define_attendance_ranges

    attendance_ranges.each do |range, value|
      return value if range.include?(attendance)
    end

    15
  end

  def define_attendance_ranges
    { 0..10_000 => 0,
      10_001..20_000 => 2,
      20_001..30_000 => 4,
      30_001..40_000 => 6,
      40_001..50_000 => 8,
      50_001..60_000 => 10,
      60_001..70_000 => 12 }
  end
end
