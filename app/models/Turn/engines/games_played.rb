class Turn::Engines::GamesPlayed
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_games_played
  end

  private

  def player_games_played
    result = Player.joins('INNER JOIN performances ON performances.player_id = players.id GROUP BY players.id')
                   .select('players.id, COUNT(players.id) AS cnt')

    players.each do |player|
      player.games_played = result.find { |record| record.id == player.id }&.cnt || 0
    end
  end
end
