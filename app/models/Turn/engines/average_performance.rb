class Turn::Engines::AveragePerformance
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_average_perfomance
  end

  private

  def player_average_perfomance
    players.each do |player|
      performances = Performance.where(player_id: player.id)
      player.average_performance = performances.average(:match_performance).to_i
    end
  end
end
