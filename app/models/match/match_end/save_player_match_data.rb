class Match::SavePlayerMatchData
  attr_reader :squads_performance, :match_info

  def initialize(squads_performance, match_info)
    @squads_performance = squads_performance
    @match_info = match_info
  end

  def call
    if @squads_performance.nil? || @match_info.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    id = match_info[:id]
    competition = match_info[:competition]

    squads_performance.each do |player|
      Performance.create(
        match_id: id,
        player_id: player[:player_id],
        club_id: player[:club_id],
        name: Player.find_by(id: player[:player_id])&.name,
        player_position: Player.find_by(id: player[:player_id])&.position,
        player_position_detail: Player.find_by(id: player[:player_id])&.player_position_detail,
        match_performance: player[:match_performance],
        competition:
      )
    end
  end
end
