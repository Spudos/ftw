class TurnReportController < ApplicationController
  def index
    if Message.any?
      @weeks = Message.all.map(&:week).uniq.sort
    else
      @weeks = []
    end

    @gm_messages = Message.where(var2: 'gm', week: params[:week_number])
    @public_messages = Message.where(var2: 'public', week: params[:week_number])
    @game_messages = Message.where(var2: 'game', week: params[:week_number])

    return unless current_user && current_user.club != 0

    @club = Club.find_by(id: current_user.club)
    @turn_present = Turnsheet.find_by(club_id: current_user.club, week: params[:week_number])
    @club_matches = Match.where(week_number: params[:week_number],
                                home_team: current_user.club)
                         .or(Match.where(week_number: params[:week_number],
                                         away_team: current_user.club))
  end
end
