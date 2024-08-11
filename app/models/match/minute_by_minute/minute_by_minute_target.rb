class Match::MinuteByMinute::MinuteByMinuteTarget
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
    home_defense = final_team.first[:defense]
    away_attack = final_team.last[:attack]
    away_defense = final_team.last[:defense]

    on_target_home = ((home_attack.to_f / away_defense) * 60).to_i
    on_target_home = on_target_home.clamp(0, 60)
    on_target_away = ((away_attack.to_f / home_defense) * 60).to_i
    on_target_away = on_target_away.clamp(0, 60)

    on_target_roll = rand(0..100)
    chance_on_target = ''

    if chance_result[:chance_outcome] == 'home' && on_target_home.to_i > on_target_roll
      chance_on_target = 'home'
    elsif chance_result[:chance_outcome] == 'away' && on_target_away.to_i > on_target_roll
      chance_on_target = 'away'
    else
      chance_on_target = 'none'
    end

    {
      on_target_home:,
      on_target_away:,
      on_target_roll:,
      chance_on_target:
    }
  end
end
