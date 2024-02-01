class Match::ChanceOnTarget
  attr_reader :chance_result, :final_team

  def initialize(chance_result, final_team)
    @chance_result = chance_result
    @final_team = final_team
  end

  def call
    home_attack = final_team.first[:attack]
    away_attack = final_team.last[:attack]
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