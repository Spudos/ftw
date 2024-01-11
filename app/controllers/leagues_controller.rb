class LeaguesController < ApplicationController
  require_relative '../services/team_statistics_calculator'

  def index
    league_information = TeamStatisticsCalculator.new
    @team_statistics = league_information.compile_league_table
  end

  def show; end
end
