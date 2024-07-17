class LeaguesController < ApplicationController
  require_relative '../services/team_statistics_calculator'

  def index
    league = params[:league]

    @table = League.where(competition: league).order(points: :desc, goal_difference: :desc, goals_for: :desc)
    @top_total_skill = Player.compile_top_total_skill_view(league)
    @top_performance = Player.compile_top_performance_view(league)
    @top_goals = Player.compile_top_goals_view(league)
    @top_assists = Player.compile_top_assists_view(league)

    @club_biggest_stadiums = League.compile_biggest_stadiums(league)
    @club_biggest_banks = League.compile_biggest_banks(league)
    @club_biggest_fanbase = League.compile_biggest_fanbase(league)
    @club_biggest_coaches = League.compile_biggest_coaches(league)
    @club_biggest_fitness = League.compile_biggest_fitness(league)
    @club_biggest_fan_happiness = League.compile_biggest_fan_happiness(league)
  end

  def league_cup
    @lc_weeks = Fixture.where(comp: 'League Cup').map(&:week_number).uniq.sort
    @lc_fixtures = Fixture.where(comp: 'League Cup', week_number: params[:week_number])
  end

  def wcc
    @wcc_weeks = Fixture.where(comp: 'WCC').map(&:week_number).uniq.sort
    @wcc_fixtures = Fixture.where(comp: 'WCC', week_number: params[:week_number])
  end

  def create_tables
    CreateLeagueTablesJob.perform_later(params[:week])

    notice = 'The create tables job has been sent for processing.'
    redirect_to request.referrer, notice:
  end
end
