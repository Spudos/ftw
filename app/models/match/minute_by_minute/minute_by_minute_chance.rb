class Match::MinuteByMinute::MinuteByMinuteChance
  attr_reader :minute_by_minute_press, :i

  def initialize(minute_by_minute_press, i)
    @minute_by_minute_press = minute_by_minute_press
    @i = i
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @minute_by_minute_press.nil? || @i.nil?

    home_dfc_rating = minute_by_minute_press.first[:defense_press]
    home_mid_rating = minute_by_minute_press.first[:midfield_press]
    home_att_rating = minute_by_minute_press.first[:attack_press]

    away_dfc_rating = minute_by_minute_press.last[:defense_press]
    away_mid_rating = minute_by_minute_press.last[:midfield_press]
    away_att_rating = minute_by_minute_press.last[:attack_press]

    random_chance_roll = rand(1..100)
    team_chance_roll = rand(0..100)
    chance = home_mid_rating - away_mid_rating
    chance_outcome = ''

    if chance >= 0 && team_chance_roll < 16
      chance_outcome = 'home'
    elsif chance.negative? && team_chance_roll < 16
      chance_outcome = 'away'
    elsif random_chance_roll <= 6
      chance_outcome = 'home'
    elsif random_chance_roll > 6 && random_chance_roll <= 11
      chance_outcome = 'away'
    else
      chance_outcome = 'none'
    end

    { chance:,
      team_chance_roll:,
      random_chance_roll:,
      chance_outcome: }
  end
end
