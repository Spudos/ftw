class Match::ChanceOnTarget
  attr_reader :chance_result, :final_team

  def initialize(chance_result, final_team)
    @chance_result = chance_result
    @final_team = final_team
  end

  def call
    if @chance_result.nil? || @final_team.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_attack = final_team.first[:attack]
    away_attack = final_team.last[:attack]
    on_target_roll = rand(0..100)
    chance_on_target = ''

    if chance_result[:chance_outcome] == 'home' && home_attack / 2 > on_target_roll
      chance_on_target = 'home'
    elsif chance_result[:chance_outcome] == 'away' && away_attack / 2 > on_target_roll
      chance_on_target = 'away'
    else
      chance_on_target = 'none'
    end
    {
      home_attack:,
      away_attack:,
      on_target_roll:,
      chance_on_target:
    }
  end
end
