class Match::PlayerPerformance
  attr_reader :match_squad

  def initialize(match_squad)
    @match_squad = match_squad
  end

  def call
    if @match_squad.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    players_array = []
    match_squad.each do |player|
      tactic = Tactic.find_by(club_id: player.club)&.tactics

      hash = {
        player_id: player.id,
        id: @id,
        club_id: player.club_id,
        player_name: player.name,
        total_skill: player.total_skill_calc,
        tactic:,
        player_position: player.position,
        player_position_detail: player.player_position_detail,
        player_blend: player.blend,
        star: player.star,
        match_performance: player.match_performance(player)
      }
      players_array << hash
    end

    players_array
  end
end
