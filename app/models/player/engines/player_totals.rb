class Player::Engines::PlayerTotals
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    result = Player.joins('INNER JOIN performances ON performances.player_id = players.id GROUP BY players.id')
                   .select('players.id, COUNT(players.id) AS cnt')
                   .select('players.id, AVG(match_performance) AS perf') # join does not include the goals table so total_goal and total_assist wont work

    players.each do |player|
      player_games_played(result, player)
      player_total_assists(player)
      player_total_goals(player)
      player_total_skill(player)
      player_average_perfomance(result, player)
    end
  end

  private

  def player_games_played(result, player)
    player.games_played = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_assists(player)
    player.total_assists = player.assists.count || 0 # CHECK
  end

  def player_total_goals(player)
    player.total_goals = player.goals.count || 0 # CHECK
  end

  def player_total_skill(player)
    player.total_skill = player.total_skill_calc
  end

  def player_average_perfomance(result, player)
    player.average_performance = result.find { |record| record.id == player.id }&.perf || 0
  end
end
