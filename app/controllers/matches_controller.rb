class MatchesController < ApplicationController
  rescue_from StandardError, with: :handle_error
  include MatchesHelper

  def index; end

  def show
    @player_match_data = player_position_sort
    @matches = Match.where(match_id: params[:id])
    @goal_information = Goal.where(match_id: params[:id])
  end

  def match_multiple
    if params[:selected_week].nil? || params[:selected_week].empty?
      return redirect_to request.referrer,
                         alert: "Please select a week before attempting to run fixtures. class:#{self.class.name}"
    end

    RunMatchesJob.perform_later(params[:selected_week], params[:competition])

    notice = 'The run matches job has been sent for processing.'
    redirect_to request.referrer, notice:
  end

  def selection_and_matches
    if params[:selected_week].nil? || params[:selected_week].empty?
      return redirect_to request.referrer,
                         alert: "Please select a week before attempting to run fixtures. class:#{self.class.name}"
    end

    MatchesJob.perform_later(params[:selected_week])

    notice = 'The selections and matches job has been sent for processing.'
    redirect_to request.referrer, notice:
  end

  def handle_error(exception)
    redirect_to request.referrer, alert: exception.message
  end

  def player_position_sort
    players = Performance.where(match_id: params[:id]).order(Arel.sql(
                                                 "CASE
                                                        WHEN player_position = 'gkp' AND player_position_detail = 'p' THEN 1
                                                        WHEN player_position = 'dfc' AND player_position_detail = 'l' THEN 2
                                                        WHEN player_position = 'dfc' AND player_position_detail = 'r' THEN 3
                                                        WHEN player_position = 'dfc' AND player_position_detail = 'c' THEN 4
                                                        WHEN player_position = 'mid' AND player_position_detail = 'l' THEN 5
                                                        WHEN player_position = 'mid' AND player_position_detail = 'r' THEN 6
                                                        WHEN player_position = 'mid' AND player_position_detail = 'c' THEN 7
                                                        WHEN player_position = 'att' AND player_position_detail = 'l' THEN 8
                                                        WHEN player_position = 'att' AND player_position_detail = 'r' THEN 9
                                                        ELSE 10
                                                        END"
                                               ))

    return players
  end
end
