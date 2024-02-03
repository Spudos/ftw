class Match::SquadCreator
  attr_reader :fixture

  def initialize(fixture)
    @fixture = fixture
  end

  def call
    if Selection.where(club: fixture[:club_home]).count == 11 && Selection.where(club: fixture[:club_away]).count == 11
      [match_info, match_squad]
    end
  end

  private

  def match_squad
    [].tap do |match_squad|
      populate_teams.each do |player_id|
        match_squad += Player.where(id: player_id)
      end
      return match_squad
    end
  end

  def populate_teams
    [].tap do |player_ids|
      match_info.each_value do |team|
        player_ids += Selection.where(club: team).pluck(:player_id)
      end
    return player_ids
    end
  end

  def match_info
    @match_info ||= # memorisation
      {
        id: fixture[:id],
        week: fixture[:week_number],
        competition: fixture[:competition],
        club_home: fixture[:club_home],
        tactic_home: Tactic.find_by(abbreviation: fixture[:club_home])&.tactics,
        dfc_aggression_home: Tactic.find_by(abbreviation: fixture[:club_home])&.dfc_aggression,
        mid_aggression_home: Tactic.find_by(abbreviation: fixture[:club_home])&.mid_aggression,
        att_aggression_home: Tactic.find_by(abbreviation: fixture[:club_home])&.att_aggression,
        club_away: fixture[:club_away],
        tactic_away: Tactic.find_by(abbreviation: fixture[:club_away])&.tactics,
        dfc_aggression_away: Tactic.find_by(abbreviation: fixture[:club_away])&.dfc_aggression,
        mid_aggression_away: Tactic.find_by(abbreviation: fixture[:club_away])&.mid_aggression,
        att_aggression_away: Tactic.find_by(abbreviation: fixture[:club_away])&.att_aggression
      }
  end
end
