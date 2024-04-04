class TeamStatisticsCalculator
  def compile_league_table(params)
    league_table_information = Hash.new { |hash, key|
          hash[key] =
        { played: 0,
          won: 0,
          lost: 0,
          drawn: 0,
          goals_scored: 0,
          goals_conceded: 0,
          points: 0 } 
        }

    match_info = Match.where(competition: params)

    match_info.each do |match|
      update_team_statistics(league_table_information, match.home_team, match.home_goals, match.away_goals)
      update_team_statistics(league_table_information, match.away_team, match.away_goals, match.home_goals)
    end
    league_table_information
  end

  private

  def update_team_statistics(team_statistics, team, goals_for, goals_against)
    stats = team_statistics[team]

    stats[:played] += 1
    stats[:goals_scored] += goals_for
    stats[:goals_conceded] += goals_against

    if goals_for > goals_against
      stats[:won] += 1
      stats[:points] += 3
    elsif goals_for < goals_against
      stats[:lost] += 1
    else
      stats[:drawn] += 1
      stats[:points] += 1
    end
  end
end
