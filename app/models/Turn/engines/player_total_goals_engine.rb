class Turn::Engines::PlayerTotalGoalsEngine
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_total_goals
    player_total_assists
    player_average_perfomance
  end

  private

  def player_total_goals
    players.each do |player|
      goals = Goal.where(scorer_id: player.id)
      player.total_goals = goals.count(:scorer_id)
    end
  end

  def player_total_assists
    players.each do |player|
      assists = Goal.where(assist_id: player.id)
      player.total_assists = assists.count(:assist_id)
    end
  end

  def player_average_perfomance
    players.each do |player|
      performances = Performance.where(player_id: player.id)
      player.average_performance = performances.average(:match_performance).to_i
    end
  end
end
