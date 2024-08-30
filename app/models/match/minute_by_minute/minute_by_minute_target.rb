class Match::MinuteByMinute::MinuteByMinuteTarget
  attr_reader :minute_by_minute_chance, :minute_by_minute_press, :midfield_on_attack, :target_factor

  def initialize(minute_by_minute_chance, minute_by_minute_press, midfield_on_attack, target_factor)
    @minute_by_minute_chance = minute_by_minute_chance
    @minute_by_minute_press = minute_by_minute_press
    @midfield_on_attack = midfield_on_attack
    @target_factor = target_factor
  end

  def call
    if @minute_by_minute_chance.nil? || @minute_by_minute_press.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_attack = minute_by_minute_press.first[:attack_press]
    home_midfield = minute_by_minute_press.first[:midfield_press]
    home_defense = minute_by_minute_press.first[:defense_press]
    away_attack = minute_by_minute_press.last[:attack_press]
    away_midfield = minute_by_minute_press.last[:midfield_press]
    away_defense = minute_by_minute_press.last[:defense_press]

    home_attack_total = home_attack + (home_midfield * midfield_on_attack)
    away_attack_total = away_attack + (away_midfield * midfield_on_attack)

    on_target_home = ((home_attack_total.to_f / away_defense) * target_factor).to_i
    on_target_home = on_target_home.clamp(0, target_factor)
    on_target_away = ((away_attack_total.to_f / home_defense) * target_factor).to_i
    on_target_away = on_target_away.clamp(0, target_factor)

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
