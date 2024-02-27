class Turn::Engines::PlayerValueEngine
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_value
  end

  private

  def player_value
    players.each do |player|
      if player.total_skill < 77
        player.value = player.total_skill * 259740
      elsif player.total_skill < 99
        player.value = player.total_skill * 505050
      elsif player.total_skill < 110
        player.value = player.total_skill * 772727
      else
        player.value = player.total_skill * 867546
      end
    end
  end
end
