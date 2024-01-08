class MatchesController < ApplicationController
  include MatchesSquadHelper
  include MatchesMinByMinHelper
  include MatchesEndOfGameHelper
  include MatchesInitializersHelper

  def index; end

  def show
    @match = Matches.find_by(match_id: params[:id])
    @pl_match = PlMatch.where(match_id: params[:id])
    @pl_stats = PlStat.where(match_id: params[:id])

    @players = []
    @pl_match.each do |pl_match|
      player = Player.find_by(id: pl_match.player_id)
      @players << player if player
    end
  end

  def match
    fixture = {
      match_id: params[:match_id],
      club_hm: params[:club_hm],
      club_aw: params[:club_aw],
      week_number: Fixtures.find_by(match_id: params[:match_id])&.week_number
    }

    initialize_sqd_setup(fixture)
    initialize_min_by_min
    initialize_end_of_game

    redirect_to show_match_path(@match_id)
  end

  def match_multiple
    fixtures = Fixtures.where(week_number: params[:selected_week])

    fixture_list = []
    fixtures.each do |fixture|
      fixture_list << {
        match_id: fixture.match_id,
        club_hm: fixture.home,
        club_aw: fixture.away,
        week_number: fixture.week_number
      }
    end
    match_week(fixture_list)
  end

  def match_week(fixture_list)
    fixture_list.each do |fixture|
      initialize_sqd_setup(fixture)
      initialize_min_by_min
      initialize_end_of_game
    end

    redirect_to fixtures_path
  end

  private

  # match sections
  #----------------------------------------------------------------
  def initialize_sqd_setup(fixture)
    @cha_count_hm = 0
    @cha_count_aw = 0
    @cha_on_tar_hm = 0
    @cha_on_tar_aw = 0
    @goal_hm = 0
    @goal_aw = 0
    @hm_poss = 0
    @aw_poss = 0

    initialize_sqd(fixture)
    initialize_sqd_pl
    initialize_tm_tot
  end

  def initialize_min_by_min
    @res = []
    rand(90..98).times do |i|
      initialize_tm_cha_val
      initialize_cha?
      initialize_cha_count
      initialize_cha_on_tar
      initialize_goal_scored?(i)
      initialize_commentary
      initialize_build_results(i)
    end
  end

  def initialize_end_of_game
    Commentary.create(@res)
    initialize_possession
    initialize_motm
    initalize_save
  end
end
