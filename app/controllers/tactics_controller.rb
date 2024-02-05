class TacticsController < ApplicationController
  def new
    @tactic = Tactic.new
  end

  def edit; end

  def update
    @tactic = Tactic.find_by(abbreviation: params[:tactic][:abbreviation])
    if @tactic.update(tactics_params)
      redirect_to club_path(params[:tactic][:abbreviation]), notice: 'Tactics were successfully updated.'
    else
      redirect_to club_path(params[:tactic][:abbreviation]), alert: 'Tactics were not successfully updated.'
    end
  end

  def create
    @tactic = Tactic.find_by(abbreviation: params[:tactic][:abbreviation])

    if tactics_params[:tactics] == ""
      redirect_to club_path(params[:tactic][:abbreviation]), alert: 'You must select a tactic.'
    else
      if @tactic.nil?
        @tactic = Tactic.new(tactics_params)
        if @tactic.save
          redirect_to club_path(params[:tactic][:abbreviation]), notice: 'Tactics created successfully.'
        else
          redirect_to club_path(params[:tactic][:abbreviation]), alert: 'Tactics not created successfully'
        end
      else
        if @tactic.update(tactics_params)
          redirect_to club_path(params[:tactic][:abbreviation]), notice: 'Tactics updated successfully.'
        else
          redirect_to club_path(params[:tactic][:abbreviation]), alert: 'Tactics not updated successfully'
        end
      end
    end
  end

  private

  def tactics_params
    params.require(:tactic).permit(:abbreviation, :tactics, :dfc_aggression, :mid_aggression, :att_aggression, :press)
  end
end
