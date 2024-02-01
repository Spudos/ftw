class Match::GoalScored
  attr_reader :chance_on_target_result, :final_team_totals

  def initialize(chance_on_target_result, final_team_totals)
    @chance_on_target_result = chance_on_target_result
    @final_team_totals = final_team_totals
  end

  def call
    home_attack = final_team_totals.first[:attack]
    away_attack = final_team_totals.last[:attack]
    goal_scored = ''

    if chance_on_target_result[:chance_on_target]  == 'home' && home_attack / 3 > rand(0..100)
      goal_scored = 'home'
    elsif chance_on_target_result[:chance_on_target] == 'away' && away_attack / 3 > rand(0..100)
      goal_scored = 'away'
    else
      goal_scored = 'none'
    end
    {
      goal_scored:
    }
  end
end