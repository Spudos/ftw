class Turn::Engines::PlayerTotalSkillEngine
  attr_reader :players, :week

  def initialize(players, week)
    @players = players
    @week = week
  end

  def process
    player_total_skill
  end

  private

  def player_total_skill
    players.each do |player|
      player.total_skill = player.total_skill
    end
  end
end
