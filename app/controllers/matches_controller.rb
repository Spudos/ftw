class MatchesController < ApplicationController
  def index; end

  def show
    @player_match_data = Performance.where(match_id: params[:id])
    @matches = Match.where(match_id: params[:id])
    @goal_information = Goal.where(match_id: params[:id])
  end

  def match_multiple
    if params[:selected_week].nil? || params[:selected_week].empty?
      flash[:notice] = "Please select a week to run the matches"
      return
    end

    match = Match.new
    match.run_matches(params)

    redirect_to fixtures_path
  end
end
