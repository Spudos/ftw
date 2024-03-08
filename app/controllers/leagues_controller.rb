class LeaguesController < ApplicationController
  require_relative '../services/team_statistics_calculator'

  def index
    league_information = TeamStatisticsCalculator.new
    @table = league_information.compile_league_table(params[:league])

    league = params[:league]
    @top_total_skill = Player.compile_top_total_skill_view(league, 'all', 'none')

    @top_total_skill_gkp = Player.compile_top_total_skill_view(league, 'gkp', 'p')

    @top_total_skill_dfc = Player.compile_top_total_skill_view(league, 'dfc', 'none')
    @top_total_skill_dfcl = Player.compile_top_total_skill_view(league, 'dfc', 'l')
    @top_total_skill_dfcc = Player.compile_top_total_skill_view(league, 'dfc', 'c')
    @top_total_skill_dfcr = Player.compile_top_total_skill_view(league, 'dfc', 'r')

    @top_total_skill_mid = Player.compile_top_total_skill_view(league, 'mid', 'none')
    @top_total_skill_midl = Player.compile_top_total_skill_view(league, 'mid', 'l')
    @top_total_skill_midc = Player.compile_top_total_skill_view(league, 'mid', 'c')
    @top_total_skill_midr = Player.compile_top_total_skill_view(league, 'mid', 'r')

    @top_total_skill_att = Player.compile_top_total_skill_view(league, 'att', 'none')
    @top_total_skill_attl = Player.compile_top_total_skill_view(league, 'att', 'l')
    @top_total_skill_attc = Player.compile_top_total_skill_view(league, 'att', 'c')
    @top_total_skill_attr = Player.compile_top_total_skill_view(league, 'att', 'r')

    @top_performance = Player.compile_top_performance_view(league, 'all', 'none')

    @top_performance_gkp = Player.compile_top_performance_view(league, 'gkp', 'p')

    @top_performance_dfc = Player.compile_top_performance_view(league, 'dfc', 'none')
    @top_performance_dfcl = Player.compile_top_performance_view(league, 'dfc', 'l')
    @top_performance_dfcc = Player.compile_top_performance_view(league, 'dfc', 'c')
    @top_performance_dfcr = Player.compile_top_performance_view(league, 'dfc', 'r')

    @top_performance_mid = Player.compile_top_performance_view(league, 'mid', 'none')
    @top_performance_midl = Player.compile_top_performance_view(league, 'mid', 'l')
    @top_performance_midc = Player.compile_top_performance_view(league, 'mid', 'c')
    @top_performance_midr = Player.compile_top_performance_view(league, 'mid', 'r')

    @top_performance_att = Player.compile_top_performance_view(league, 'att', 'none')
    @top_performance_attl = Player.compile_top_performance_view(league, 'att', 'l')
    @top_performance_attc = Player.compile_top_performance_view(league, 'att', 'c')
    @top_performance_attr = Player.compile_top_performance_view(league, 'att', 'r')

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
