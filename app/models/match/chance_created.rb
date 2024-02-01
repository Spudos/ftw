class Match::ChanceCreated
  attr_reader :final_team, :i

  def initialize(final_team, i)
    @final_team = final_team
    @i = i
  end

  def call
    random_number = rand(1..100)
    chance = final_team.first[:midfield] - final_team.last[:midfield]
    chance_outcome = ''

    if chance >= 0 && rand(0..100) < 16
      chance_outcome = 'home'
    elsif chance.negative? && rand(0..100) < 16
      chance_outcome = 'away'
    elsif random_number <= 5
      chance_outcome = 'home'
    elsif random_number > 5 && random_number <= 10
      chance_outcome = 'away'
    else
      chance_outcome = 'none'
    end

    chance_result = {
      minute: i,
      chance_outcome:
    }
    chance_result
  end
end
