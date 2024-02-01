class Match::MatchLists
  attr_reader :final_squad_totals

  def initialize(final_squad_totals)
    @final_squad_totals = final_squad_totals
  end

  def call
    home_list, away_list = Match::PlayerList.new(final_squad_totals).call
    home_top_five, away_top_five = Match::TopFive.new(home_list, away_list).call

    return home_top_five, away_top_five, home_list, away_list
  end
end