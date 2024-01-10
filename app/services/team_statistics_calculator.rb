class TeamStatisticsCalculator
  def initialize(match_info)
    @match_info = match_info
    @team_statisticsistics = Hash.new { |hash, key| hash[key] = { played: 0, won: 0, lost: 0, drawn: 0, goals_scored: 0, goals_conceded: 0, points: 0 } }
  end

  def calculate_team_statistics
    @match_info.each do |match|
      update_team_statistics(match.home_team, match.home_goals, match.away_goals)
      update_team_statistics(match.away_team, match.away_goals, match.home_goals)
    end

    @team_statistics
  end

  private

  def update_team_statistics(team, goals_for, goals_against)
    @team_statistics[team][:played] += 1
    @team_statistics[team][:goals_scored] += goals_for
    @team_statistics[team][:goals_conceded] += goals_against

    if goals_for > goals_against
      @team_statistics[team][:won] += 1
      @team_statistics[team][:points] += 3
    elsif goals_for < goals_against
      @team_statistics[team][:lost] += 1
    else
      @team_statistics[team][:drawn] += 1
      @team_statistics[team][:points] += 1
    end
  end
end
