class Match::PlayerList
  attr_reader :final_squad_totals

  def initialize(final_squad_totals)
    @final_squad_totals = final_squad_totals
  end

  def call
    home_team = final_squad_totals.first[:club]
    home_list = []
    away_list = []

    final_squad_totals.each do |player|
      if player[:club] == home_team
        home_list << { player_id: player[:player_id], player_position: player[:player_position],match_performance: player[:match_performance] }
      else
        away_list << { player_id: player[:player_id], player_position: player[:player_position],match_performance: player[:match_performance] }
      end
    end
   return home_list, away_list
  end
end