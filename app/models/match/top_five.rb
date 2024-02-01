class Match::TopFive
  attr_reader :home_list, :away_list

  def initialize(home_list, away_list)
    @home_list = home_list
    @away_list = away_list
  end

  def call
    home_top_5 = home_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    away_top_5 = away_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    return home_top_5, away_top_5
  end
end