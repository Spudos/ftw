class TacticsController < ApplicationController
  def new
    @tactic = Tactic.new
  end

  def create
    @tactic = Tactic.find_or_initialize_by(abbreviation: params[:tactic][:abbreviation])

    if @tactic.new_record?
      if @tactic.save
        redirect_to @tactic, notice: 'Tactic was successfully created.'
      else
        render :new
      end
    else
      if @tactic.update(tactics_params)
        redirect_to @tactic, notice: 'Tactic was successfully updated.'
      else
        render :new
      end
    end
  end

  private

  def tactics_params
    params.require(:tactic).permit(:tactics, :dfc_aggression, :mid_aggression, :att_aggression)
  end
end
