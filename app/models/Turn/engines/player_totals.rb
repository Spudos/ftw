class Turn::Engines::PlayerTotals
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    players.each do |player|
      player_games_played(player)
      player_total_assists(player)
      player_total_goals(player)
      player_total_skill(player)
      player_average_perfomance(player)
    end
  end

  private

  def player_games_played(player)
    result = Player.joins('INNER JOIN performances ON performances.player_id = players.id GROUP BY players.id')
                   .select('players.id, COUNT(players.id) AS cnt')

    player.games_played = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_assists(player)
    result = Player.joins('INNER JOIN goals ON goals.assist_id = players.id GROUP BY players.id')
                   .select('players.id, COUNT(players.id) AS cnt')

    player.total_assists = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_goals(player)
    result = Player.joins('INNER JOIN goals ON goals.scorer_id = players.id GROUP BY players.id')
                   .select('players.id, COUNT(players.id) AS cnt')

    player.total_goals = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_skill(player)
    player.total_skill = player.total_skill_calc
  end

  def player_average_perfomance(player)
    result = Player.joins('INNER JOIN performances ON performances.player_id = players.id GROUP BY players.id')
                   .select('players.id, AVG(match_performance) AS cnt')

    player.average_performance = result.find { |record| record.id == player.id }&.cnt || 0
  end
end
