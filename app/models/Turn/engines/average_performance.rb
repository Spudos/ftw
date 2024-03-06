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
    result = Player.joins('INNER JOIN performances ON performances.player_id = players.id GROUP BY players.id')
                   .select('players.id, AVG(match_performance) AS cnt')

    players.each do |player|
      player.average_performance = result.find { |record| record.id == player.id }&.cnt || 0
    end
  end
end
