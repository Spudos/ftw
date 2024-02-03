class Match::MatchLists
  attr_reader :final_squad

  def initialize(final_squad)
    @final_squad = final_squad
  end

  def call
    if @final_squad.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_list, away_list = Match::PlayerList.new(final_squad).call
    home_top, away_top = Match::TopFive.new(home_list, away_list).call

    return home_top, away_top, home_list, away_list
  end
end