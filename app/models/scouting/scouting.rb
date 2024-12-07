class Scouting::Scouting
  attr_reader :scout_info

  def initialize(scout_info)
    @scout_info = scout_info
    @week = scout_info[:week]
    @club_id = scout_info[:club_id]
    @skills = scout_info[:skills]
    @potential_skill = scout_info[:potential_skill]
    @blend_player = scout_info[:blend_player]
  end

  def call
    players = Scouting::Engines::SearchForPlayers.new(@scout_info).call

    if @skills || @potential_skill
      players = Scouting::Engines::SecondaryFilters.new(players, @skills, @potential_skill).call
    end

    players = Scouting::Engines::BlendMatching.new(players, @blend_player).call if @blend_player != 0

    Scouting::Engines::ReportSearchResult.new(@week, @club_id, players.sample).call
  end
end
