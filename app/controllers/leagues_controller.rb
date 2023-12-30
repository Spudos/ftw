class LeaguesController < ApplicationController
  def index
    @match_info = Matches.all
    @team_stats = calculate_team_stats(@match_info)
  end

  def show
  end

  def calculate_team_stats(match_info)
    team_stats = Hash.new { |hash, key| hash[key] = { played: 0, won: 0, lost: 0, drawn: 0, goals_scored: 0, goals_conceded: 0, points: 0 } }

    match_info.each do |match|
      update_team_stats(team_stats, match.hm_team, match.hm_goal, match.aw_goal)
      update_team_stats(team_stats, match.aw_team, match.aw_goal, match.hm_goal)
    end

    team_stats
  end

  private

  def update_team_stats(team_stats, team, goals_for, goals_against)
    team_stats[team][:played] += 1
    team_stats[team][:goals_scored] += goals_for
    team_stats[team][:goals_conceded] += goals_against

    if goals_for > goals_against
      team_stats[team][:won] += 1
      team_stats[team][:points] += 3
    elsif goals_for < goals_against
      team_stats[team][:lost] += 1
    else
      team_stats[team][:drawn] += 1
      team_stats[team][:points] += 1
    end
  end
end

