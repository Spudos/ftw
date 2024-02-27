class Turn::Engines::PlayerGamesPlayedEngine
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
    players.each do |player|
      performances = Performance.where(player_id: player.id)
      player.games_played = performances.count(:match_performance)
    end
  end
end
