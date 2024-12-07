class Scouting::Engines::BlendMatching
  attr_reader :players, :blend_player

  def initialize(players, blend_player)
    @players = players
    @blend_player = blend_player
  end

  def call
    blend_matching(@players) if @blend_player != 0
  end

  private

  def blend_matching(players)
    players_with_blend = []
    blend_to_match = Player.find_by(id: @blend_player).blend

    players.each do |player|
      next unless player.blend == blend_to_match

      players_with_blend << player
    end

    players_with_blend
  end
end
