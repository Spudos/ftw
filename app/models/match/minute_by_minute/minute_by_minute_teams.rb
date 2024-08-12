class Match::MinuteByMinute::MinuteByMinuteTeams
  attr_reader :minute_by_minute_blend, :fixture_attendance

  def initialize(minute_by_minute_blend, fixture_attendance)
    @minute_by_minute_blend = minute_by_minute_blend
    @fixture_attendance = fixture_attendance
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @minute_by_minute_blend.nil?
    all_teams = []
    fixture_attendance.each do |fixture|
      match_teams = match_team_array(fixture[:club_home], fixture[:club_away])
      all_teams << match_teams
    end

    all_teams
  end

  private

  def match_team_array(home, away)
    home_team = build_home_team(home)
    away_team = build_away_team(away)

    [home_team, away_team]
  end

  def build_home_team(home)
    defense = 0
    midfield = 0
    attack = 0

    minute_by_minute_blend.each do |player|
      next if player[:club_id] != home

      case player[:position]
      when 'gkp', 'dfc'
        defense += player[:performance]
      when 'mid'
        midfield += player[:performance]
      when 'att'
        attack += player[:performance]
      end
    end
    home_team = { club_id: home, defense:, midfield:, attack:}
  end

  def build_away_team(away)
    defense = 0
    midfield = 0
    attack = 0

    minute_by_minute_blend.each do |player|
      next if player[:club_id] != away

      case player[:position]
      when 'gkp', 'dfc'
        defense += player[:performance]
      when 'mid'
        midfield += player[:performance]
      when 'att'
        attack += player[:performance]
      end
    end
    away_team = { club_id: away, defense:, midfield:, attack:}
  end
end
