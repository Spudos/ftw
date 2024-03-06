class Turn::Engines::TotalAssists
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_total_assists
  end

  private

  def player_total_assists
    result = Player.joins('INNER JOIN goals ON goals.assist_id = players.id GROUP BY players.id')
                   .select('players.id, COUNT(players.id) AS cnt')

    players.each do |player|
      player.total_assists = result.find { |record| record.id == player.id }&.cnt || 0
    end
  end
end
