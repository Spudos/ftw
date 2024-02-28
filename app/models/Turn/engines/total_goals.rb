class Turn::Engines::TotalGoals
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_total_goals
  end

  private

  def player_total_goals
    players.each do |player|
      goals = Goal.where(scorer_id: player.id)
      player.total_goals = goals.count(:scorer_id)
    end
  end
end
