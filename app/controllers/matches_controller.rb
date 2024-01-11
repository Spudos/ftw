class MatchesController < ApplicationController
  # include MatchesMinByMinHelper
  # include MatchesEndOfGameHelper
  # include MatchesInitializersHelper

  def index; end

  def show
    @match = Matches.find_by(match_id: params[:id])
    @pl_match = PlMatch.where(match_id: params[:id])
    @pl_statistics = PlStat.where(match_id: params[:id])

    @players = []
    @pl_match.each do |pl_match|
      player = Player.find_by(id: pl_match.player_id)
      @players << player if player
    end
  end

  # def match
  #   fixture = {
  #     match_id: params[:match_id],
  #     club_home: params[:club_home],
  #     club_awayay: params[:club_awayay],
  #     week_number: Fixtures.find_by(match_id: params[:match_id])&.week_number
  #   }

  #   initialize_squad_setup(fixture)
  #   initialize_minute_by_minute
  #   initialize_end_of_game

  #   redirect_to show_match_path(@match_id)
  # end

  # def match_multiple
  #   fixtures = Fixtures.where(week_number: params[:selected_week])

  #   fixture_list = []
  #   fixtures.each do |fixture|
  #     fixture_list << {
  #       match_id: fixture.match_id,
  #       club_home: fixture.home,
  #       club_awayay: fixture.away,
  #       week_number: fixture.week_number
  #     }
  #   end
  #   match_week(fixture_list)
  # end

  def match_multiple
    match = Matches.new
    match.match_engine(params)

    redirect_to fixtures_path
  end

  private

  # match sections
  #----------------------------------------------------------------
  # def initialize_squad_setup(fixture)
  #   @chance_count_home = 0
  #   @chance_count_away = 0
  #   @chance_on_target_home = 0
  #   @chance_on_target_away = 0
  #   @goal_home = 0
  #   @goal_away = 0
  #   @home_possession = 0
  #   @away_possession = 0

  #   initialize_sqd(fixture)
  #   initialize_squad_pl
  #   initialize_team_total
  # end

  # def initialize_minute_by_minute
  #   @res = []
  #   rand(90..98).times do |i|
  #     initialize_team_chance_val
  #     initialize_chance?
  #     initialize_chance_count
  #     initialize_chance_on_target
  #     initialize_goal_scored?(i)
  #     initialize_commentary
  #     initialize_build_results(i)
  #   end
  # end

  # def initialize_end_of_game
  #   Commentary.create(@res)
  #   initialize_possessionession
  #   initialize_man_of_the_match
  #   initalize_save
  # end
end
