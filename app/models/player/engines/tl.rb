class Player::Engines::Tl
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    players.each do |player|
      tl_decrease(player)
    end

    players
  end

  private

  def tl_decrease(player)
    if player.tl > 0
      player.tl -= 1
    end
  end
end
