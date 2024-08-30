class Match::MinuteByMinute::MinuteByMinuteScored
  attr_reader :minute_by_minute_target, :minute_by_minute_press, :goal_factor

  def initialize(minute_by_minute_target, minute_by_minute_press, goal_factor)
    @minute_by_minute_target = minute_by_minute_target
    @minute_by_minute_press = minute_by_minute_press
    @goal_factor = goal_factor
  end

  def call
    if @minute_by_minute_target.nil? || @minute_by_minute_press.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_attack = minute_by_minute_press.first[:attack_press]
    home_defense = minute_by_minute_press.first[:defense_press]
    away_attack = minute_by_minute_press.last[:attack_press]
    away_defense = minute_by_minute_press.last[:defense_press]

    goal_home = ((home_attack.to_f / away_defense) * goal_factor).to_i
    goal_home = goal_home.clamp(0, goal_factor)

    goal_away = ((away_attack.to_f / home_defense) * goal_factor).to_i
    goal_away = goal_away.clamp(0, goal_factor)

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
