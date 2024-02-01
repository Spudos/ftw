class Match < ApplicationRecord
  def run_matches(params)
    fixture_list = Match::CreateFixtures.new(params).call

    fixture_list.each do |fixture|
      final_squad, match_info = squad(fixture)
      final_team, match_info = teams(final_squad, match_info)
      minute_by_minute, home_list, away_list = match(final_team, final_squad, match_info)
      detailed_match_summary = match_end(home_list, away_list, minute_by_minute)
      save_match(detailed_match_summary, home_list, away_list, minute_by_minute)
    end
  end

  private

  def squad(fixture)
    match_info, match_squad = Match::SquadCreator.new(fixture).call
    squads_performance = Match::PlayerPerformance.new(match_squad).call
    squad_tactics = Match::TacticAdjustment.new(squads_performance).call
    final_squad = Match::StarEffect.new(squad_tactics).call
    Match::SavePlayerMatchData.new(final_squad, match_info).call
    Match::PlayerFitness.new(final_squad, match_info).call

    return final_squad, match_info
  end

  def teams(final_squad, match_info)
    totals = Match::TeamTotals.new(final_squad).call
    totals_blend, blend_totals = Match::BlendAdjustment.new(totals).call
    match_info = Match::BlendAdd.new(blend_totals, match_info).call
    home_stadium = Match::StadiumSize.new(totals_blend).call
    totals_stadium = Match::StadiumEffect.new(totals_blend, home_stadium).call
    final_team = Match::AggressionEffect.new(totals_stadium).call

    return final_team, match_info
  end

  def match(final_team, final_squad, match_info)
    home_top, away_top, home_list, away_list = Match::MatchLists.new(final_squad).call

    minute_by_minute = []
    rand(90..98).times do |i|
      chance_result = Match::ChanceCreated.new(final_team, i).call
      chance_on_target_result = Match::ChanceOnTarget.new(chance_result, final_team).call
      goal_scored = Match::GoalScored.new(chance_on_target_result, final_team).call
      assist, scorer = Match::Names.new(goal_scored, home_top, away_top).call

      minute_by_minute << { **match_info, **chance_result, **chance_on_target_result, **goal_scored, **assist, **scorer }
    end

    return minute_by_minute, home_list, away_list
  end

  def match_end(home_list, away_list, minute_by_minute)
    detailed_match_summary = []
    match_summary = Match::MatchSummary.new(minute_by_minute).call
    possession = Match::Possession.new(match_summary).call
    man_of_the_match = Match::ManOfTheMatch.new(home_list, away_list).call
    detailed_match_summary << { **match_summary, **possession, **man_of_the_match }

    return detailed_match_summary
  end

  def save_match(detailed_match_summary, home_list, away_list, minute_by_minute)
    Match::SaveDetailedMatchSummary.new(detailed_match_summary).call
    Match::SaveGoalAndAssistInformation.new(minute_by_minute).call
    Match::SaveMatchCommentary.new(home_list, away_list, minute_by_minute).call
  end
end
