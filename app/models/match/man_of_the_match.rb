class Match::ManOfTheMatch
  attr_reader :home_list, :away_list

  def initialize(home_list, away_list)
    @home_list = home_list
    @away_list = away_list
  end

  def call
    home_man_of_the_match = home_list.max_by { |player| player[:match_performance] }[:player_id]
    away_man_of_the_match = away_list.max_by { |player| player[:match_performance] }[:player_id]

    { home_man_of_the_match:, away_man_of_the_match:}
  end
end
