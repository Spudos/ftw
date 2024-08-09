class Match < ApplicationRecord
  has_many :home_teams, class_name: 'Clubs', foreign_key: 'home_team_id'
  has_many :away_teams, class_name: 'Clubs', foreign_key: 'home_team_id'

  def run_matches(selected_week, competition)
    fixture_list, selections, tactics = initialize_match(selected_week, competition)
    players = initialize_player(selections, tactics)
    minute_by_minute(fixture_list, players, tactics)
    match_end(fixture_list, selections, tactics)

    turn.update(run_matches: true)
  end

  private

  def initialize_match(selected_week, competition)
    fixture_list = Match::InitializeMatch::GetFixture.new(selected_week, competition).call
    selection = Match::InitializeMatch::GetSelection.new(fixture_list).call
    tactic = Match::InitializeMatch::GetTactic.new(fixture_list).call

    return fixture_list, selection, tactic
  end

  def initialize_player(selection, tactic)
    selection_performance = Match::InitializePlayer::SelectionPerformance.new(selection).call
    selection_tactic = Match::InitializePlayer::SelectionTactic.new(selection_performance, tactic).call
    selection_star = Match::InitializePlayer::StarEffect.new(selection_tactic).call
    selection_fitness = Match::InitializePlayer::PlayerFitness.new(selection_star).call
    selection_stadium = Match::InitializePlayer::StadiumEffect.new(selection_fitness).call
    selection_aggression = Match::InitializePlayer::AggressionEffect.new(selection_stadium).call
  end

  def minute_by_minute(fixture_list, selections, tactics)
    minute_by_minute = []
    rand(90..98).times do |i|
      match_team = Match::MinuteByMinute::PressingEffect.new(final_team, i).call
      totals_blend, blend_totals = Match::MinuteByMinute::BlendAdjustment.new(totals).call

      chance_result = Match::MinuteByMinute::ChanceCreated.new(match_team, i).call
      chance_on_target_result = Match::MinuteByMinute::ChanceOnTarget.new(chance_result, match_team).call
      goal_scored = Match::MinuteByMinute::GoalScored.new(chance_on_target_result, match_team).call
      assist, scorer = Match::MinuteByMinute::Names.new(goal_scored, home_top, away_top).call

      minute_by_minute << { **match_info,
                            **chance_result,
                            **chance_on_target_result,
                            **goal_scored,
                            **assist,
                            **scorer }
    end
  end

  def match_end(fixture_list, selections, tactics)
    Match::MatchEnd::SaveDetailedMatchSummary.new(detailed_match_summary, attendance).call
    Match::MatchEnd::SaveGoalAndAssistInformation.new(minute_by_minute).call
    Match::MatchEnd::SaveMatchCommentary.new(home_list, away_list, minute_by_minute).call
    Match::MatchEnd::MatchLogging.new(minute_by_minute).call
  end
end
