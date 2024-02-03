class Match::TopFive
  attr_reader :home_list, :away_list

  def initialize(home_list, away_list)
    @home_list = home_list
    @away_list = away_list
  end

  def call
    if @home_list.nil? || @away_list.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end
    
    home_top = home_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    away_top = away_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    return home_top, away_top
  end
end