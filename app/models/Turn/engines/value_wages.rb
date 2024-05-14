class Turn::Engines::ValueWages
  attr_reader :players, :week

  def initialize(players, week, x)
    @players = players
    @week = week
    @x = x
  end

  def process
    @x.report('player_value_wages') { player_value_wages }
  end

  private

  def player_value_wages
    players.each do |player|
      player_skill = player.total_skill_calc
      if player_skill < 77
        player.value = player_skill * 259740
        player.wages = player_skill * 445
      elsif player_skill < 99
        player.value = player_skill * 505050
        player.wages = player_skill * 1025
      elsif player.total_skill < 110
        player.value = player_skill * 772727
        player.wages = player_skill * 1587
      else
        player.value = player_skill * 867546
        player.wages = player_skill * 2181
      end
    end
  end
end
