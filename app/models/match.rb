class Match < ApplicationRecord
  has_many :home_teams, class_name: 'Clubs', foreign_key: 'home_team_id'
  has_many :away_teams, class_name: 'Clubs', foreign_key: 'home_team_id'

  def run_matches(selected_week, competition)
    fixture_list, selections, tactics = initialize_match(selected_week, competition)

    binding.pry

    initilize_player(fixture_list, selections, tactics)
    minute_by_minute(fixture_list, selections, tactics)
    match_end(fixture_list, selections, tactics)

    turn.update(run_matches: true)
  end

  private

  def initialize_match(selected_week, competition)
    fixture_list = Match::InitializeMatch::GetFixtures.new(selected_week, competition).call
    selections = Match::InitializeMatch::GetSelections.new(fixture_list).call
    tactics = Match::InitializeMatch::GetTactics.new(fixture_list).call

    return fixture_list, selections, tactics
  end

  def initilize_player(fixture_list, selections, tactics)
    selection_performance = Match::InitalizePlayer::PlayerPerformance.new(match_squad).call
    selection_tactics = Match::InitalizePlayer::TacticAdjustment.new(squads_performance).call
    selection_star = Match::InitalizePlayer::StarEffect.new(squad_tactics).call
    selection_fitness = Match::InitalizePlayer::PlayerFitness.new(final_squad, match_info).call
    selection_stadium = Match::InitalizePlayer::StadiumEffect.new(totals_blend, attendance).call
    selection_aggression = Match::InitalizePlayer::AggressionEffect.new(totals_stadium).call

    selection_aggression
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
