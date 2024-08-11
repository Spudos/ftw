class Match::MinuteByMinute::MinuteByMinuteChance
  attr_reader :final_team, :i

  def initialize(final_team, i)
    @final_team = final_team
    @i = i
  end

  def call
    raise StandardError, "There was an error in the #{self.class.name} class" if @final_team.nil? || @i.nil?

    home_def_rating = final_team.first[:defense]
    home_mid_rating = final_team.first[:midfield]
    home_att_rating = final_team.first[:attack]

    away_def_rating = final_team.last[:defense]
    away_mid_rating = final_team.last[:midfield]
    away_att_rating = final_team.last[:attack]

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

    chance_result = {
      minute: i,
      home_def_rating:,
      home_mid_rating:,
      home_att_rating:,
      away_def_rating:,
      away_mid_rating:,
      away_att_rating:,
      chance:,
      team_chance_roll:,
      random_chance_roll:,
      chance_outcome:
    }
    chance_result
  end
end
