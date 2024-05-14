class Turn::Engines::PlayerTotals
  attr_reader :players, :week

  def initialize(players, week, x)
    @players = players
    @week = week
    @x = x
  end

  def process
    @x.report('whatever') { whatever }
  end

  private

  def whatever
    performances = Performance.select('player_id, COUNT(player_id) AS cnt').where("player_id IN (#{players.pluck(:id).join(',')})").group(:player_id)

    games_played = [].tap do |array|
      performances.as_json.each do |performance|
        array << { id: performance['player_id'], games_played: performance['cnt'] }
      end
    end

    games_played = games_played.reject(&:empty?)

    Player.upsert_all(games_played) if games_played.present?
    Player.upsert_all(games_played) if games_played.present?
    Player.upsert_all(games_played) if games_played.present?
    Player.upsert_all(games_played) if games_played.present?
    Player.upsert_all(games_played) if games_played.present?

    # players.each do |player|
    #   player_games_played(result, player)
    #   player_total_assists(result, player)
    #   player_total_goals(result, player)
    #   player_total_skill(player)
    #   player_average_perfomance(result, player)
    # end
  end

  def player_games_played(result, player)
    player.games_played = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_assists(result, player)
    player.total_assists = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_goals(result, player)
    player.total_goals = result.find { |record| record.id == player.id }&.cnt || 0
  end

  def player_total_skill(player)
    player.total_skill = player.total_skill_calc
  end

  def player_average_perfomance(result, player)
    player.average_performance = result.find { |record| record.id == player.id }&.cnt || 0
  end
end
