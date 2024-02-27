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
        player.wages = player.total_skill * 845
      elsif player.total_skill < 99
        player.wages = player.total_skill * 2025
      elsif player.total_skill < 110
        player.wages = player.total_skill * 3287
      else
        player.wages = player.total_skill * 4181
      end
    end
  end
end
