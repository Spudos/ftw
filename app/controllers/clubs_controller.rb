class ClubsController < ApplicationController
  before_action :set_club, only: [:show, :edit, :update, :destroy]

  # GET /clubs or /clubs.json
  def index
    @clubs = Club.all
  end

  # GET /clubs/1 or /clubs/1.json
  def show
    @selection = Selection.where(club: params[:id])
    @players = Player.where(club: params[:id])
    @club_matches = Matches.where('hm_team = ? OR aw_team = ?', params[:id], params[:id])
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs or /clubs.json
  def create
    @club = Club.new(club_params)

    respond_to do |format|
      if @club.save
        format.html { redirect_to club_url(@club), notice: "Club was successfully created." }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clubs/1 or /clubs/1.json
  def update
    @club = Club.find_by(abbreviation: params[:club][:abbreviation])
    respond_to do |format|
      if @club.update(club_params)
        format.html { redirect_to clubs_url, notice: "Club was successfully updated." }
        format.json { render :show, status: :ok, location: @club }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1 or /clubs/1.json
  def destroy
    @club.destroy

    respond_to do |format|
      format.html { redirect_to clubs_url, notice: "Club was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find_by(abbreviation: params[:id])
    end
    

    # Only allow a list of trusted parameters through.
    def club_params
      params.require(:club).permit(:name, :abbreviation)
    end
end
