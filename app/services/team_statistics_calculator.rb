class TeamStatisticsCalculator
  def compile_league_table
    league_table_information = Hash.new { |hash, key|
      hash[key] =
        { played: 0,
          won: 0,
          lost: 0,
          drawn: 0,
          goals_scored: 0,
          goals_conceded: 0,
          points: 0 } }

    match_info = Matches.all

    match_info.each do |match|
      update_team_statistics(league_table_information, match.home_team, match.home_goals, match.away_goals)
      update_team_statistics(league_table_information, match.away_team, match.away_goals, match.home_goals)
    end
    league_table_information
  end

  private

  def update_team_statistics(league_table_information, team, goals_for, goals_against)
    league_table_information[team][:played] += 1
    league_table_information[team][:goals_scored] += goals_for
    league_table_information[team][:goals_conceded] += goals_against

    if goals_for > goals_against
      league_table_information[team][:won] += 1
      league_table_information[team][:points] += 3
    elsif goals_for < goals_against
      league_table_information[team][:lost] += 1
    else
      league_table_information[team][:drawn] += 1
      league_table_information[team][:points] += 1
    end
  end
end
