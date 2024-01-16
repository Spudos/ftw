module Matches
  class SquadCreator
    attr_reader :fixture

    def initialize(fixture)
      @fixture = fixture
    end

    def create_squad_for_game
      [teams_to_be_played, match_squad]
    end

    private

    def match_squad
      [].tap do |match_squad|
        populate_teams.each do |player_id|
          match_squad += Player.where(id: player_id)
        end
      end
    end

    def populate_teams
      [].tap do |player_ids|
        teams_to_be_played.each_value do |team|
          player_ids += Selection.where(club: team).pluck(:player_id)
        end
      end
    end

    def teams_to_be_played
      @teams_to_be_played ||= # memoisation
        {
          id: fixture[:id],
          week: fixture[:week_number],
          competition: fixture[:competition],
          club_home: fixture[:club_home],
          tactic_home: Tactic.find_by(abbreviation: fixture[:club_home])&.tactics,
          club_away: fixture[:club_away],
          tactic_away: Tactic.find_by(abbreviation: fixture[:club_away])&.tactics
        }
    end
  end
end
