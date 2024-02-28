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
    players.each do |player|
      assists = Goal.where(assist_id: player.id)
      player.total_assists = assists.count(:assist_id)
    end
  end
end
