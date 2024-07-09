class Turn::Engines::PlayerTotals
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    result = Player.joins('INNER JOIN performances ON performances.player_id = players.id GROUP BY players.id')
                   .select('players.id, COUNT(players.id) AS cnt')

    players.each do |player|
      player_games_played(result, player)
      player_total_assists(result, player)
      player_total_goals(result, player)
      player_total_skill(player)
      player_average_perfomance(result, player)
    end
  end

  private

  def player_games_played(result, player)
    player.games_played = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_assists(result, player)
    player.total_assists = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_goals(result, player)
    binding.pry
    player.total_goals = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_skill(player)
    player.total_skill = player.total_skill_calc
  end

  def player_average_perfomance(result, player)
    player.average_performance = result.find { |record| record.id == player.id }&.cnt || 0
  end
end
