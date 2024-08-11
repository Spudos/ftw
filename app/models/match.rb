class Match < ApplicationRecord
  has_many :home_teams, class_name: 'Clubs', foreign_key: 'home_team_id'
  has_many :away_teams, class_name: 'Clubs', foreign_key: 'home_team_id'

  def run_matches(selected_week, competition)
    fixture_list, selection, tactic = initialize_match(selected_week, competition)

    selection_complete, fixture_attendance = initialize_player(selection, tactic, fixture_list)

    minute_by_minute(fixture_attendance, selection_complete, tactic)

    match_end(fixture_attendance, selection, tactic)

    turn.update(run_matches: true)
  end

  private

  def initialize_match(selected_week, competition)
    fixture_list = Match::InitializeMatch::GetFixture.new(selected_week, competition).call
    selection = Match::InitializeMatch::GetSelection.new(fixture_list).call
    tactic = Match::InitializeMatch::GetTactic.new(fixture_list).call

    return fixture_list, selection, tactic
  end

  def initialize_player(selection, tactic, fixture_list)
    selection_performance = Match::InitializePlayer::SelectionPerformance.new(selection).call
    selection_tactic = Match::InitializePlayer::SelectionTactic.new(selection_performance, tactic).call
    selection_star = Match::InitializePlayer::SelectionStar.new(selection_tactic).call
    selection_stadium, fixture_attendance = \
      Match::InitializePlayer::SelectionStadium.new(selection_star, fixture_list).call
    selection_complete = Match::InitializePlayer::SelectionAggression.new(selection_stadium, tactic).call

    return selection_complete, fixture_attendance
  end

  def minute_by_minute(fixture_attendance, selection_complete, tactic)
    rand(90..98).times do |i|
      selection_match = Match::MinuteByMinute::BlendAdjustment.new(selection_complete).call

      all_teams = Match::MinuteByMinute::MinuteByMinuteTeams.new(selection_match, fixture_attendance).call

      all_teams.each do |match_team|
        minute_by_minute_press = Match::MinuteByMinute::PressingEffect.new(match_team, tactic, i).call
        minute_by_minute_chance = Match::MinuteByMinute::ChanceCreated.new(minute_by_minute_press, i).calls
        minute_by_minute_target = Match::MinuteByMinute::ChanceOnTarget.new(minute_by_minute_chance, selection_match).call
        minute_by_minute_scored = Match::MinuteByMinute::GoalScored.new(minute_by_minute_target, selection_match).call

        assist, scorer = Match::MinuteByMinute::Names.new(minute_by_minute_scored).call
      end
    end
  end

  def match_end(fixture_attendance, selection_complete, tactic)
    Match::MatchEnd::SaveDetailedMatchSummary.new().call
    Match::MatchEnd::SaveGoalAndAssistInformation.new().call
    Match::MatchEnd::SaveMatchCommentary.new().call
    Match::MatchEnd::MatchLogging.new().call
    Match::FitnessUpdate.new(selection_complete).call
  end
end
