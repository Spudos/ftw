class TurnReportController < ApplicationController
  def index
    @weeks = Message.all.map(&:week).uniq.sort
    @gm_messages = Message.where(var2: 'gm', week: params[:week_number])
    @public_messages = Message.where(var2: 'public', week: params[:week_number])
    @game_messages = Message.where(var2: 'game', week: params[:week_number])
  end
end
