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
  end

  def league_cup
    @lc_weeks = Fixture.where(comp: 'League Cup').map(&:week_number).uniq.sort
    @lc_fixtures = Fixture.where(comp: 'League Cup', week_number: params[:week_number])
  end

  def wcc
    @wcc_weeks = Fixture.where(comp: 'WCC').map(&:week_number).uniq.sort
    @wcc_fixtures = Fixture.where(comp: 'WCC', week_number: params[:week_number])
  end
end
