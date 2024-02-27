class Turn::Engines::PlayerWagesEngine
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_wages
  end

  private

  def player_wages
    players.each do |player|
      if player.total_skill < 77
        player.wages = player.total_skill * 445
      elsif player.total_skill < 99
        player.wages = player.total_skill * 1025
      elsif player.total_skill < 110
        player.wages = player.total_skill * 1587
      else
        player.wages = player.total_skill * 2181
      end
    end
  end
end
