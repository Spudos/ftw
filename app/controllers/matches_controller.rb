class MatchesController < ApplicationController
  def index; end

  def show
    @player_match_data = Performance.where(match_id: params[:id])
    @matches = Match.where(match_id: params[:id])
    @goal_information = Goal.where(match_id: params[:id])
  end

  def match_multiple
    match = Match.new
    match.run_matches(params)

    redirect_to fixtures_path
  end
end
