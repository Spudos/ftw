class LeaguesController < ApplicationController
  require_relative '../services/team_statistics_calculator'
  
  def index
    @match_info = Matches.all
    @team_statistics = calculate_team_statistics(@match_info)
  end

  def show; end

  def calculate_team_statistics(match_info)
    team_stats_calculator = TeamStatisticsCalculator.new(match_info)
    team_stats_calculator.calculate_team_statistics
  end
end
