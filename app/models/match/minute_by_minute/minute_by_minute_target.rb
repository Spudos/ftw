class Match::MinuteByMinute::MinuteByMinuteTarget
  attr_reader :minute_by_minute_chance, :selection_match

  def initialize(minute_by_minute_chance, selection_match)
    @minute_by_minute_chance = minute_by_minute_chance
    @selection_match = selection_match
  end

  def call
    if @minute_by_minute_chance.nil? || @selection_match.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_attack = selection_match.first[:attack]
    home_defense = selection_match.first[:defense]
    away_attack = selection_match.last[:attack]
    away_defense = selection_match.last[:defense]

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
