class Match::ChanceOnTarget
  attr_reader :chance_result, :final_team_totals

  def initialize(chance_result, final_team_totals)
    @chance_result = chance_result
    @final_team_totals = final_team_totals
  end

  def call
    home_attack = final_team_totals.first[:attack]
    away_attack = final_team_totals.last[:attack]
    chance_on_target = ''

    if chance_result[:chance_outcome] == 'home' && home_attack / 2 > rand(0..100)
      chance_on_target = 'home'
    elsif chance_result[:chance_outcome] == 'away' && away_attack / 2 > rand(0..100)
      chance_on_target = 'away'
    else
      chance_on_target = 'none'
    end
    {
      chance_on_target: chance_on_target
    }
  end
end