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

  def ligue_2_league_table
    initialize_table('Ligue 2')
    render 'leagues/ligue_2/table'
  end

  def ligue_2_statistics
    initialize_statistics('Ligue 2')
    render 'leagues/ligue_2/statistics'
  end

  def ligue_2_fixtures
    initialize_fixtures('Ligue 2')
    render 'leagues/ligue_2/fixtures'
  end

  def bundesliga_1_league_table
    initialize_table('Bundesliga 1')
    render 'leagues/bundesliga_1/table'
  end

  def bundesliga_1_statistics
    initialize_statistics('Bundesliga 1')
    render 'leagues/bundesliga_1/statistics'
  end

  def bundesliga_1_fixtures
    initialize_fixtures('Bundesliga 1')
    render 'leagues/bundesliga_1/fixtures'
  end

  def bundesliga_2_league_table
    initialize_table('Bundesliga 2')
    render 'leagues/bundesliga_2/table'
  end

  def bundesliga_2_statistics
    initialize_statistics('Bundesliga 2')
    render 'leagues/bundesliga_2/statistics'
  end

  def bundesliga_2_fixtures
    initialize_fixtures('Bundesliga 2')
    render 'leagues/bundesliga_2/fixtures'
  end

  def brasileiro_serie_a_league_table
    initialize_table('Brasileiro Serie A')
    render 'leagues/brasileiro_serie_a/table'
  end

  def brasileiro_serie_a_statistics
    initialize_statistics('Brasileiro Serie A')
    render 'leagues/brasileiro_serie_a/statistics'
  end

  def brasileiro_serie_a_fixtures
    initialize_fixtures('Brasileiro Serie A')
    render 'leagues/brasileiro_serie_a/fixtures'
  end

  def brasileiro_serie_b_league_table
    initialize_table('Brasileiro Serie B')
    render 'leagues/brasileiro_serie_b/table'
  end

  def brasileiro_serie_b_statistics
    initialize_statistics('Brasileiro Serie B')
    render 'leagues/brasileiro_serie_b/statistics'
  end

  def brasileiro_serie_b_fixtures
    initialize_fixtures('Brasileiro Serie B')
    render 'leagues/brasileiro_serie_b/fixtures'
  end

  def serie_a_league_table
    initialize_table('Serie A')
    render 'leagues/serie_a/table'
  end

  def serie_a_statistics
    initialize_statistics('Serie A')
    render 'leagues/serie_a/statistics'
  end

  def serie_a_fixtures
    initialize_fixtures('Serie A')
    render 'leagues/serie_a/fixtures'
  end

  def serie_b_league_table
    initialize_table('Serie B')
    render 'leagues/serie_b/table'
  end

  def serie_b_statistics
    initialize_statistics('Serie B')
    render 'leagues/serie_b/statistics'
  end

  def serie_b_fixtures
    initialize_fixtures('Serie B')
    render 'leagues/serie_b/fixtures'
  end

  def la_liga_league_table
    initialize_table('La Liga')
    render 'leagues/la_liga/table'
  end

  def la_liga_statistics
    initialize_statistics('La Liga')
    render 'leagues/la_liga/statistics'
  end

  def la_liga_fixtures
    initialize_fixtures('La Liga')
    render 'leagues/la_liga/fixtures'
  end

  def segunda_division_league_table
    initialize_table('Segunda Division')
    render 'leagues/segunda_division/table'
  end

  def segunda_division_statistics
    initialize_statistics('Segunda Division')
    render 'leagues/segunda_division/statistics'
  end

  def segunda_division_fixtures
    initialize_fixtures('Segunda Division')
    render 'leagues/segunda_division/fixtures'
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
