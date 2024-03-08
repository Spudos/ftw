class Turn::Engines::Wages
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
      player_skill = player.total_skill_calc
      if player_skill < 77
        player.wages = player_skill * 445
      elsif player_skill < 99
        player.wages = player_skill * 1025
      elsif player_skill < 110
        player.wages = player_skill * 1587
      else
        player.wages = player_skill * 2181
      end
    end
  end
end
