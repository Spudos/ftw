class Match::PlayerList
  attr_reader :final_squad

  def initialize(final_squad)
    @final_squad = final_squad
  end

  def call
    if @final_squad.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end
    home_team = final_squad.first[:club_id]
    home_list = []
    away_list = []

    final_squad.each do |player|
      if player[:club_id] == home_team
        home_list << { player_id: player[:player_id], player_position: player[:player_position],match_performance: player[:match_performance] }
      else
        away_list << { player_id: player[:player_id], player_position: player[:player_position],match_performance: player[:match_performance] }
      end
    end
   return home_list, away_list
  end
end