class TacticsController < ApplicationController
  def new
    @tactic = Tactic.new
  end

  def create
    @tactic = Tactic.find_or_initialize_by(abbreviation: params[:abbreviation])

    if @tactic.new_record?
      if @tactic.save
        redirect_to @tactic, notice: 'Tactic was successfully created.'
      else
        render :new
      end
    else
      if @tactic.update(tactics: params[:tactic][:tactics])
        redirect_to @tactic, notice: 'Tactic was successfully updated.'
      else
        render :new
      end
    end
  end
end
