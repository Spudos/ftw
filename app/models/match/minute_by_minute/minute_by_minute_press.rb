class Match::MinuteByMinute::MinuteByMinutePress
  attr_reader :match_teams, :tactic, :i

  def initialize(match_teams, tactic, i)
    @match_teams = match_teams
    @tactic = tactic
    @i = i
  end

  def call
    pressing = press_information

    multiplier = get_multiplier

    minute_by_minute_press = { club_id: match_teams[0][:club_id],
                               defense_press: match_teams[0][:defense],
                               midfield_press: match_teams[0][:midfield] + (pressing[:home_press] * multiplier),
                               attack_press: match_teams[0][:attack] + (pressing[:home_press] * multiplier) },
                             { club_id: match_teams[1][:club_id],
                               defense_press: match_teams[1][:defense],
                               midfield_press: match_teams[1][:midfield] + (pressing[:away_press] * multiplier),
                               attack_press: match_teams[1][:attack] + (pressing[:away_press] * multiplier) }

    return minute_by_minute_press
  end

  private

  def press_information
    home_tactic = tactic.find { |hash| hash[:club_id] == match_teams[0][:club_id] }
    home_press = home_tactic[:press]

    away_tactic = tactic.find { |hash| hash[:club_id] == match_teams[1][:club_id] }
    away_press = away_tactic[:press]

    { home_press:, away_press: }
  end

  def get_multiplier
    case @i
    when 0...10
      6
    when 10...20
      5
    when 20...30
      4
    when 30...40
      3
    when 40...50
      2
    when 50...60
      1
    when 60...70
      0
    when 70...80
      -2
    when 80...90
      -4
    when 90...100
      -6
    end
  end
end
