class SelectionsController < ApplicationController
  before_action :set_selection, only: %i[show edit update destroy]
  def index
    @selections = Selection.all
    @clubs = Club.all

    return unless params[:club_id].present?

    @selected_club = Selection.where(club_id: params[:club_id])
  end

  def show; end

  def new
    @selection = Selection.new
  end

  def edit; end

  def create
    club = Club.find_by(id: params[:selection]["club_id"])
    player_ids = (1..11).map { |index| params[:selection]["player_#{index}"].to_i }.reject { |id| id.zero? }

    if player_ids.nil? || player_ids.size != 11
      flash[:alert] = "You must select 11 players, you selected #{player_ids.count}."
      redirect_to request.referrer
    else
      Selection.where(club_id: club.id).delete_all

      player_ids.each do |player_id|
        Selection.create(club_id: club.id, player_id:)
      end
      flash[:notice] = 'Selection saved successfully.'
      redirect_to request.referrer
    end
  end

  def update
    respond_to do |format|
      if @selection.update(selection_params)
        format.html { redirect_to selection_url(@selection), notice: 'Selection was successfully updated.' }
        format.json { render :show, status: :ok, location: @selection }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @selection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @selection.destroy

    respond_to do |format|
      format.html { redirect_to selections_url, notice: 'Selection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def auto_selection
    AutoSelectionJob.perform_later(params[:week])

    notice = 'The auto selection job has been sent for processing.'
    redirect_to request.referrer, notice:
  end

  private

  def set_selection
    @selection = Selection.find(params[:id])
  end

  def selection_params
    params.require(:selection).permit(:club, :player_id)
  end
end
