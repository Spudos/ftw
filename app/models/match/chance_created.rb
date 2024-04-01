class Match::ChanceCreated
  attr_reader :final_team, :i

  def initialize(final_team, i)
    @final_team = final_team
    @i = i
  end

  def call
    if @final_team.nil? || @i.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_mid_rating = final_team.first[:midfield]
    away_mid_rating = final_team.last[:midfield]
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
      home_mid_rating:,
      away_mid_rating:,
      chance:,
      team_chance_roll:,
      random_chance_roll:,
      chance_outcome:
    }
    chance_result
  end
end
