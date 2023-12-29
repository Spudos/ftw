class SelectionsController < ApplicationController
  before_action :set_selection, only: %i[ show edit update destroy ]

  # GET /selections or /selections.json
  def index
    @selections = Selection.all
  end

  # GET /selections/1 or /selections/1.json
  def show
  end

  # GET /selections/new
  def new
    @selection = Selection.new
  end

  # GET /selections/1/edit
  def edit
  end

  # POST /selections or /selections.json
  def create
   
    club = Club.find_by(abbreviation: params[:club])
    player_ids = params[:player_ids].map(&:to_i)
    
    # Delete previous entries for the selected club
    Selection.where(club: club.abbreviation).delete_all
    
    # Save the new selection
    player_ids.each do |player_id|
      Selection.create(club: club.abbreviation, player_id: player_id)
    end
    
    redirect_to clubs_path, notice: "Selection saved successfully."
  end
  

  # PATCH/PUT /selections/1 or /selections/1.json
  def update
    respond_to do |format|
      if @selection.update(selection_params)
        format.html { redirect_to selection_url(@selection), notice: "Selection was successfully updated." }
        format.json { render :show, status: :ok, location: @selection }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /selections/1 or /selections/1.json
  def destroy
    @selection.destroy

    respond_to do |format|
      format.html { redirect_to selections_url, notice: "Selection was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_selection
      @selection = Selection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def selection_params
      params.require(:selection).permit(:club, :player_id)
    end
end
