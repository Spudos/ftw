class Match::GoalScored
  attr_reader :chance_on_target_result, :final_team

  def initialize(chance_on_target_result, final_team)
    @chance_on_target_result = chance_on_target_result
    @final_team = final_team
  end

  def call
    if @chance_on_target_result.nil? || @final_team.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_attack = final_team.first[:attack]
    home_defense = final_team.first[:defense]
    away_attack = final_team.last[:attack]
    away_defense = final_team.last[:defense]

    goal_home = ((home_attack.to_f / away_defense) * 40).to_i
    goal_home = goal_home.clamp(0, 40)

    goal_away = ((away_attack.to_f / home_defense) * 40).to_i
    goal_away = goal_away.clamp(0, 40)

    goal_roll = rand(0..100)
    goal_scored = ''

    if chance_on_target_result[:chance_on_target]  == 'home' && goal_home > goal_roll
      goal_scored = 'home'
    elsif chance_on_target_result[:chance_on_target] == 'away' && goal_away > goal_roll
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
