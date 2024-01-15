class LeaguesController < ApplicationController
  require_relative '../services/team_statistics_calculator'

  def index
    league_information = TeamStatisticsCalculator.new
    @team_statistics = league_information.compile_league_table(params[:competition])
    @top_total_skill = Player.compile_top_total_skill_view(params[:competition])
    @top_performance = Player.compile_top_performance_view(params[:competition])
    @top_goals = Player.compile_top_goals_view(params[:competition])
    @top_assists = Player.compile_top_assists_view(params[:competition])
  end

  def show; end
end
