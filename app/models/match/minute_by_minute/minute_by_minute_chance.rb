class Match::MinuteByMinute::MinuteByMinuteChance
  attr_reader :minute_by_minute_press, :i, :chance_factor

  def initialize(minute_by_minute_press, i, chance_factor)
    @minute_by_minute_press = minute_by_minute_press
    @i = i
    @chance_factor = chance_factor
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @minute_by_minute_press.nil? || @i.nil?

    home_mid_rating = minute_by_minute_press.first[:midfield_press]
    home_att_rating = minute_by_minute_press.first[:attack_press]

    away_mid_rating = minute_by_minute_press.last[:midfield_press]
    away_att_rating = minute_by_minute_press.last[:attack_press]

    home_rating = home_mid_rating + home_att_rating
    away_rating = away_mid_rating + away_att_rating
    total_rating = home_rating + away_rating

    home_chance = (((home_rating.to_f / total_rating) * 100) / chance_factor).round(0)
    away_chance = (((away_rating.to_f / total_rating) * 100) / chance_factor).round(0)

    chance_roll = rand(0..100)

    if chance_roll <= home_chance
      chance_outcome = 'home'
    elsif chance_roll <= (home_chance + away_chance)
      chance_outcome = 'away'
    else
      chance_outcome = 'none'
    end

    { home_chance:,
      away_chance:,
      chance_roll:,
      chance_outcome: }
  end
end
