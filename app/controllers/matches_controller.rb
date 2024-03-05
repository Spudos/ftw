class MatchesController < ApplicationController
  rescue_from StandardError, with: :handle_error
  include MatchesHelper

  def index; end

  def show
    @player_match_data = Performance.where(match_id: params[:id])
    @matches = Match.where(match_id: params[:id])
    @goal_information = Goal.where(match_id: params[:id])
  end

  def match_multiple
    if params[:selected_week].nil? || params[:selected_week].empty?
      return redirect_to request.referrer, alert: "Please select a week before attempting to run fixtures. class:#{self.class.name}"
    end

    match = Match.new
    match.run_matches(params)
    notice = 'Matches ran successfully.'
    redirect_to request.referrer, notice: notice
  end

  def handle_error(exception)
    redirect_to request.referrer, alert: exception.message
  end
end
