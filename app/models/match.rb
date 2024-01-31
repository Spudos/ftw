class Match < ApplicationRecord
  def run_matches(params)
    fixture_list = fixtures_for_week(params)

    fixture_list.each do |fixture|
      match_info, match_squad = Match::SquadCreator.new(fixture).run

      squads_with_performance = Match::PlayerPerformance.new(match_squad).run
      squads_with_tactics = Match::TacticAdjustment.new(squads_with_performance).run
      final_squad_totals = Match::StarEffect.new(squads_with_tactics).run

      Match::SavePlayerMatchData.new(final_squad_totals, match_info).save
      Match::PlayerFitness.new(final_squad_totals, match_info).run

      totals = Match::TeamTotals.new(final_squad_totals).run
      totals_with_blend, blend_totals = Match::Blends.new(totals).run
      match_info = add_blend(blend_totals, match_info)
      home_stadium = stadium_size(totals_with_blend)
      totals_with_stadium = teams_with_stadium_effect(totals_with_blend, home_stadium)
      final_team_totals = totals_with_aggression_effect(totals_with_stadium)

      run_match_logic(final_team_totals, final_squad_totals, match_info)
    end
  end

  def run_match_logic(final_team_totals, final_squad_totals, match_info)
    home_list, away_list = list_of_players(final_squad_totals)
    home_top_5, away_top_5 = list_of_top_5_players(home_list, away_list)

    minute_by_minute = []
    rand(90..98).times do |i|
      chance_result = chance_created(final_team_totals, i)
      chance_on_target_result = if_chance_on_target(chance_result, final_team_totals)
      goal_scored = goal_scored(chance_on_target_result, final_team_totals)

      if goal_scored[:goal_scored] != 'none'
        assist = assisted(home_top_5, away_top_5, goal_scored)
        scorer = scored(home_top_5, away_top_5, assist, goal_scored)
      else
        assist = { assist_id: 'none' }
        scorer = { scorer: 'none' }
      end

      minute_by_minute << { **match_info, **chance_result, **chance_on_target_result, **goal_scored, **assist, **scorer }
    end
    run_end_of_match(home_list, away_list, minute_by_minute)
  end

  def run_end_of_match(home_list, away_list, minute_by_minute)
    detailed_match_summary = []
    match_summary = Match::MatchSummary.new(minute_by_minute).run
    possession = possession(match_summary)
    man_of_the_match = man_of_the_match(home_list, away_list)
    detailed_match_summary << { **match_summary, **possession, **man_of_the_match }

    Match::SaveDetailedMatchSummary.new(detailed_match_summary).save
    Match::SaveGoalAndAssistInformation.new(minute_by_minute).save
    Match::MatchCommentary.new(home_list, away_list, minute_by_minute).run
  end

  private

  def fixtures_for_week(params)
    if params[:competition] == nil
      fixtures = Fixture.where(week_number: params[:selected_week])
    else
      fixtures = Fixture.where(week_number: params[:selected_week], comp: params[:competition])
    end

    fixture_list = []
    fixtures.each do |fixture|
      fixture_list << {
        id: fixture.id,
        club_home: fixture.home,
        club_away: fixture.away,
        week_number: fixture.week_number,
        competition: fixture.comp
      }
    end
    fixture_list
  end

  def add_blend(blend_totals, match_info)
    updated_match_info = match_info.merge(
      {
        dfc_blend_home: blend_totals[0][:defense],
        mid_blend_home: blend_totals[0][:midfield],
        att_blend_home: blend_totals[0][:attack],
        dfc_blend_away: blend_totals[1][:defense],
        mid_blend_away: blend_totals[1][:midfield],
        att_blend_away: blend_totals[1][:attack]
      }
    )
    updated_match_info
  end

  def stadium_size(totals_with_blend)
    club = Club.find_by(abbreviation: totals_with_blend.first[:team])
    stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

    stadium_size
  end

  def teams_with_stadium_effect(totals_with_blend, home_stadium_size)
    if home_stadium_size <= 10000
      stadium_effect = 0
    elsif home_stadium_size <= 20000
      stadium_effect = 2
    elsif home_stadium_size <= 30000
      stadium_effect = 3
    elsif home_stadium_size <= 40000
      stadium_effect = 4
    elsif home_stadium_size <= 50000
      stadium_effect = 5
    elsif home_stadium_size <= 60000
      stadium_effect = 6
    elsif home_stadium_size <= 70000
      stadium_effect = 7
    else
      stadium_effect = 10
    end

    totals_with_blend.first[:defense] += stadium_effect
    totals_with_blend.first[:midfield] += stadium_effect
    totals_with_blend.first[:attack] += stadium_effect

    totals_with_blend
  end

  def totals_with_aggression_effect(totals_with_stadium)
    totals_with_aggression = []

    totals_with_stadium.each do |team|
      hash = {
        team: team[:team],
        defense: team[:defense] + Tactic.find_by(abbreviation: team[:team])&.dfc_aggression * 5,
        midfield: team[:midfield] + Tactic.find_by(abbreviation: team[:team])&.mid_aggression * 5,
        attack: team[:attack] + Tactic.find_by(abbreviation: team[:team])&.att_aggression * 5
      }
      totals_with_aggression << hash
    end
    return totals_with_aggression
  end

  def chance_created(final_team_totals, i)
    random_number = rand(1..100)
    chance = final_team_totals.first[:midfield] - final_team_totals.last[:midfield]
    chance_outcome = ''

    if chance >= 0 && rand(0..100) < 16
      chance_outcome = 'home'
    elsif chance.negative? && rand(0..100) < 16
      chance_outcome = 'away'
    elsif random_number <= 5
      chance_outcome = 'home'
    elsif random_number > 5 && random_number <= 10
      chance_outcome = 'away'
    else
      chance_outcome = 'none'
    end

    chance_result = {
      minute: i,
      chance_outcome:
    }
    chance_result
  end

  def if_chance_on_target(chance_result, final_team_totals)
    home_attack = final_team_totals.first[:attack]
    away_attack = final_team_totals.last[:attack]
    chance_on_target = ''

    if chance_result[:chance_outcome] == 'home' && home_attack / 2 > rand(0..100)
      chance_on_target = 'home'
    elsif chance_result[:chance_outcome] == 'away' && away_attack / 2 > rand(0..100)
      chance_on_target = 'away'
    else
      chance_on_target = 'none'
    end
    {
      chance_on_target: chance_on_target
    }
  end

  def goal_scored(chance_on_target_result, final_team_totals)
    home_attack = final_team_totals.first[:attack]
    away_attack = final_team_totals.last[:attack]
    goal_scored = ''

    if chance_on_target_result[:chance_on_target]  == 'home' && home_attack / 3 > rand(0..100)
      goal_scored = 'home'
    elsif chance_on_target_result[:chance_on_target] == 'away' && away_attack / 3 > rand(0..100)
      goal_scored = 'away'
    else
      goal_scored = 'none'
    end
    {
      goal_scored:
    }
  end

  def list_of_players(final_squad_totals)
    home_team = final_squad_totals.first[:club]
    home_list = []
    away_list = []

    final_squad_totals.each do |player|
      if player[:club] == home_team
        home_list << { player_id: player[:player_id], player_position: player[:player_position],match_performance: player[:match_performance] }
      else
        away_list << { player_id: player[:player_id], player_position: player[:player_position],match_performance: player[:match_performance] }
      end
    end
   return home_list, away_list
  end

  def list_of_top_5_players(home_list, away_list)
    home_top_5 = home_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    away_top_5 = away_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    return home_top_5, away_top_5
  end

  def assisted(home_top_5, away_top_5, goal_scored)
    if goal_scored[:goal_scored] == 'home'
      assist = home_top_5.sample[:player_id]
    else
      assist = away_top_5.sample[:player_id]
    end
    { assist: }
  end

  def scored(home_top_5, away_top_5, assist, goal_scored)
    if goal_scored[:goal_scored] == 'home'
      scorer = home_top_5.reject { |player| player[:player_id] == assist }.sample[:player_id]
    else
      scorer = away_top_5.reject { |player| player[:player_id] == assist }.sample[:player_id]
    end

    while scorer == assist
      if goal_scored[:goal_scored] == 'home'
        scorer = home_top_5.reject { |player| player[:player_id] == assist }.sample[:player_id]
      else
        scorer = away_top_5.reject { |player| player[:player_id] == assist }.sample[:player_id]
      end
    end

    { scorer: }
  end

  def possession(match_summary)
    home_possession = (match_summary[:chance_count_home] / (match_summary[:chance_count_home] + match_summary[:chance_count_away]).to_f * 80).to_i
    away_possession = 100 - home_possession

    { home_possession:, away_possession:}
  end

  def man_of_the_match(home_list, away_list)
    home_man_of_the_match = home_list.max_by { |player| player[:match_performance] }[:player_id]
    away_man_of_the_match = away_list.max_by { |player| player[:match_performance] }[:player_id]

    { home_man_of_the_match:, away_man_of_the_match:}
  end
end

#------------------------------------------------------------------------------
# Match
#
# Name                  SQL Type             Null    Primary Default
# --------------------- -------------------- ------- ------- ----------
# id                    INTEGER              false   true              
# match_id              INTEGER              true    false             
# home_team             varchar              true    false             
# away_team             varchar              true    false             
# home_possession       INTEGER              true    false             
# away_possession       INTEGER              true    false             
# home_chance           INTEGER              true    false             
# away_chance           INTEGER              true    false             
# home_chance_on_target INTEGER              true    false             
# away_chance_on_target INTEGER              true    false             
# home_man_of_the_match varchar              true    false             
# away_man_of_the_match varchar              true    false             
# created_at            datetime(6)          false   false             
# updated_at            datetime(6)          false   false             
# home_goals            INTEGER              true    false             
# away_goals            INTEGER              true    false             
# week_number           INTEGER              true    false             
# tactic_home           INTEGER              true    false             
# tactic_away           INTEGER              true    false             
# competition           varchar              true    false             
# dfc_aggression_home   INTEGER              true    false             
# mid_aggression_home   INTEGER              true    false             
# att_aggression_home   INTEGER              true    false             
# dfc_aggression_away   INTEGER              true    false             
# mid_aggression_away   INTEGER              true    false             
# att_aggression_away   INTEGER              true    false             
# dfc_blend_home        INTEGER              true    false             
# mid_blend_home        INTEGER              true    false             
# att_blend_home        INTEGER              true    false             
# dfc_blend_away        INTEGER              true    false             
# mid_blend_away        INTEGER              true    false             
# att_blend_away        INTEGER              true    false             
#
#------------------------------------------------------------------------------
