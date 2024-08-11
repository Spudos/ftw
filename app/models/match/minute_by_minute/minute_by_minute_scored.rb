class Match::MinuteByMinute::MinuteByMinuteScored
  attr_reader :minute_by_minute_target, :selection_match

  def initialize(minute_by_minute_target, selection_match)
    @minute_by_minute_target = minute_by_minute_target
    @selection_match = selection_match
  end

  def call
    if @minute_by_minute_target.nil? || @selection_match.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_attack = selection_match.first[:attack]
    home_defense = selection_match.first[:defense]
    away_attack = selection_match.last[:attack]
    away_defense = selection_match.last[:defense]

    goal_home = ((home_attack.to_f / away_defense) * 40).to_i
    goal_home = goal_home.clamp(0, 40)

    goal_away = ((away_attack.to_f / home_defense) * 40).to_i
    goal_away = goal_away.clamp(0, 40)

    goal_roll = rand(0..100)
    goal_scored = ''

    if minute_by_minute_target[:chance_on_target]  == 'home' && goal_home > goal_roll
      goal_scored = 'home'
    elsif minute_by_minute_target[:chance_on_target] == 'away' && goal_away > goal_roll
      goal_scored = 'away'
    else
      goal_scored = 'none'
    end
    {
      goal_home:,
      goal_away:,
      goal_roll:,
      goal_scored:
    }
  end
end
