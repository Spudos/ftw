class LeaguesController < ApplicationController
  require_relative '../services/team_statistics_calculator'

  def index; end

  def show; end

  def premier_league_table
    initialize_table('Premier League')
    render 'leagues/premier/table'
  end

  def premier_league_statistics
    initialize_statistics('Premier League')
    render 'leagues/premier/statistics'
  end

  def premier_league_fixtures
    initialize_fixtures('Premier League')
    render 'leagues/premier/fixtures'
  end

  def championship_league_table
    initialize_table('Championship')
    render 'leagues/championship/table'
  end

  def championship_league_statistics
    initialize_statistics('Championship')
    render 'leagues/championship/statistics'
  end

  def championship_league_fixtures
    initialize_fixtures('Championship')
    render 'leagues/championship/fixtures'
  end

  def ligue_1_league_table
    initialize_table('Ligue 1')
    render 'leagues/ligue_1/table'
  end

  def ligue_1_statistics
    initialize_statistics('Ligue 1')
    render 'leagues/ligue_1/statistics'
  end

  def ligue_1_fixtures
    initialize_fixtures('Ligue 1')
    render 'leagues/ligue_1/fixtures'
  end

  def league_cup
    initialize_fixtures('Cup')
    render 'leagues/cup/league'
  end

  private

  def initialize_table(league)
    league_information = TeamStatisticsCalculator.new
    @team_statistics = league_information.compile_league_table(league)
  end

  def initialize_statistics(league)
    @top_total_skill = Player.compile_top_total_skill_view(league, 'all')
    @top_total_skill_gkp = Player.compile_top_total_skill_view(league, 'gkp')
    @top_total_skill_dfc = Player.compile_top_total_skill_view(league, 'dfc')
    @top_total_skill_mid = Player.compile_top_total_skill_view(league, 'mid')
    @top_total_skill_att = Player.compile_top_total_skill_view(league, 'att')
    @top_performance = Player.compile_top_performance_view(league)
    @top_goals = Player.compile_top_goals_view(league)
    @top_assists = Player.compile_top_assists_view(league)
  end

  def initialize_fixtures(league)
    @weeks = Fixture.distinct.pluck(:week_number).uniq
    @fixtures = Fixture.where(comp: league, week_number: params[:week_number])
  end
end
