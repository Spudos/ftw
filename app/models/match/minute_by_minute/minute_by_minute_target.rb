class Match::MinuteByMinute::MinuteByMinuteTarget
  attr_reader :minute_by_minute_chance, :match_team

  def initialize(minute_by_minute_chance, match_team)
    @minute_by_minute_chance = minute_by_minute_chance
    @match_team = match_team
  end

  def call
    if @minute_by_minute_chance.nil? || @match_team.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_attack = match_team.first[:attack]
    home_defense = match_team.first[:defense]
    away_attack = match_team.last[:attack]
    away_defense = match_team.last[:defense]

    on_target_home = ((home_attack.to_f / away_defense) * 60).to_i
    on_target_home = on_target_home.clamp(0, 60)
    on_target_away = ((away_attack.to_f / home_defense) * 60).to_i
    on_target_away = on_target_away.clamp(0, 60)

    on_target_roll = rand(0..100)
    chance_on_target = ''

    chance_on_target = if minute_by_minute_chance[:chance_outcome] == 'home' && on_target_home.to_i > on_target_roll
                         'home'
                       elsif minute_by_minute_chance[:chance_outcome] == 'away' && on_target_away.to_i > on_target_roll
                         'away'
                       else
                         'none'
                       end

    {
      on_target_home:,
      on_target_away:,
      on_target_roll:,
      chance_on_target:
    }
  end
end
