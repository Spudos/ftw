class Match::MatchEnd::MatchEndPerformance
  attr_reader :fixture_attendance, :selection_complete

  def initialize(fixture_attendance, selection_complete)
    @fixture_attendance = fixture_attendance
    @selection_complete = selection_complete
  end

  def call
    if @fixture_attendance.nil? || @selection_complete.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    player_upload = summarise_players

    player_attributes = player_upload.to_a.map(&:as_json)
    Performance.upsert_all(player_attributes)
  end

  private

  def summarise_players
    player_info = []

    fixture_attendance.each do |record|
      selection_complete.each do |player|
        if record[:club_home] == player[:club_id] || record[:club_away] == player[:club_id]
          player_info << { match_id: record[:id],
                           player_id: player[:player_id],
                           club_id: player[:club_id],
                           name: player[:name],
                           player_position: player[:position],
                           player_position_detail: player[:position_detail],
                           match_performance: player[:performance],
                           competition: record[:competition] }
        end
      end
    end

    player_info
  end
end
