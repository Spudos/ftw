class Match::SquadCreator
  attr_reader :fixture

  def initialize(fixture)
    @fixture = fixture
  end

  def call
    tactics_check

    home_selection = Selection.where(club_id: fixture[:club_home]).size
    away_selection = Selection.where(club_id: fixture[:club_away]).size
    home_player_ids = Selection.where(club_id: fixture[:club_home]).pluck(:player_id).compact.size
    away_player_ids = Selection.where(club_id: fixture[:club_away]).pluck(:player_id).compact.size

    if home_selection != 11 || away_selection != 11
      raise StandardError, "Team #{fixture[:club_home]} have selected #{home_selection} players, Team #{fixture[:club_away]} have selected #{away_selection} players.  Both teams must have 11 players selected.  This game and all subsequent games have not been run. class:#{self.class.name} class."
    elsif home_player_ids != 11 || away_player_ids != 11
      raise StandardError, "Team #{fixture[:club_home]} has #{home_player_ids} player_ids, Team #{fixture[:club_away]} has #{away_player_ids} players.  Both teams must have 11 player_ids selected.  This game and all subsequent games have not been run. class:#{self.class.name} class."
    else
      [match_info, match_squad]
    end
  end

  private

  def tactics_check
    home_tactic = Tactic.find_by(club_id: fixture[:club_home])
    away_tactic = Tactic.find_by(club_id: fixture[:club_away])

    if home_tactic.nil?
      Tactic.create(club_id: fixture[:club_home], tactics: 1, dfc_aggression: 0, mid_aggression: 0, att_aggression: 0, press: 3)
    elsif home_tactic&.dfc_aggression.nil? || home_tactic&.mid_aggression.nil? || home_tactic&.att_aggression.nil? || home_tactic&.press.nil?
      home_tactic.update(dfc_aggression: 0, mid_aggression: 0, att_aggression: 0, press: 3)
    end

    if away_tactic.nil?
      Tactic.create(club_id: fixture[:club_away], tactics: 1, dfc_aggression: 0, mid_aggression: 0, att_aggression: 0, press: 3)
    elsif away_tactic&.dfc_aggression.nil? || away_tactic&.mid_aggression.nil? || away_tactic&.att_aggression.nil? || away_tactic&.press.nil?
      away_tactic.update(dfc_aggression: 0, mid_aggression: 0, att_aggression: 0, press: 3)
    end
  end

  def match_squad
    [].tap do |match_squad|
      populate_teams.each do |player_id|
        match_squad += Player.where(id: player_id)
      end
      return match_squad
    end
  end

  def populate_teams
    player_ids = []
    player_ids += Selection.where(club_id: match_info[:club_home].to_i).pluck(:player_id)
    player_ids += Selection.where(club_id: match_info[:club_away].to_i).pluck(:player_id)
    player_ids
  end

  def match_info
    @match_info ||= # memorisation
      {
        id: fixture[:id],
        week: fixture[:week_number],
        competition: fixture[:competition],
        club_home: fixture[:club_home],
        tactic_home: Tactic.find_by(club_id: fixture[:club_home])&.tactics,
        dfc_aggression_home: Tactic.find_by(club_id: fixture[:club_home])&.dfc_aggression,
        mid_aggression_home: Tactic.find_by(club_id: fixture[:club_home])&.mid_aggression,
        att_aggression_home: Tactic.find_by(club_id: fixture[:club_home])&.att_aggression,
        home_press: Tactic.find_by(club_id: fixture[:club_home])&.press,
        club_away: fixture[:club_away],
        tactic_away: Tactic.find_by(club_id: fixture[:club_away])&.tactics,
        dfc_aggression_away: Tactic.find_by(club_id: fixture[:club_away])&.dfc_aggression,
        mid_aggression_away: Tactic.find_by(club_id: fixture[:club_away])&.mid_aggression,
        att_aggression_away: Tactic.find_by(club_id: fixture[:club_away])&.att_aggression,
        away_press: Tactic.find_by(club_id: fixture[:club_away])&.press
      }
  end
end
