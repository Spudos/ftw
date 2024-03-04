class LeaguesController < ApplicationController
  require_relative '../services/team_statistics_calculator'

  def index
    league_information = TeamStatisticsCalculator.new
    @table = league_information.compile_league_table(params[:league])

    league = params[:league]
    @top_total_skill = Player.compile_top_total_skill_view(league, 'all')
    @top_total_skill_gkp = Player.compile_top_total_skill_view(league, 'gkp')
    @top_total_skill_dfc = Player.compile_top_total_skill_view(league, 'dfc')
    @top_total_skill_mid = Player.compile_top_total_skill_view(league, 'mid')
    @top_total_skill_att = Player.compile_top_total_skill_view(league, 'att')
    @top_performance = Player.compile_top_performance_view(league)
    @top_goals = Player.compile_top_goals_view(league)
    @top_assists = Player.compile_top_assists_view(league)

    week_fixtures
  end

  def league_cup
    week_fixtures
  end

  def wcc
    week_fixtures
  end

  private

  def week_fixtures
    weeks = Fixture.distinct.pluck(:week_number).uniq
    @weeks = weeks.sort!

    week_number = params[:week_number].presence || 1
    @fixtures = Fixture.where(comp: params[:league], week_number: week_number)
  end
end
