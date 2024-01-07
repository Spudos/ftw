class TurnsController < ApplicationController
  include TurnsHelper
  include TurnsStadiumHelper
  include TurnsPlayerHelper
  include TurnsCoachesHelper

  before_action :set_turn, only: %i[ show edit update destroy ]

  # GET /turns or /turns.json
  def index
    @turns = Turn.all
  end

  # GET /turns/1 or /turns/1.json
  def show
  end

  # GET /turns/new
  def new
    @turn = Turn.new
  end

  # GET /turns/1/edit
  def edit
  end

  # POST /turns or /turns.json
  def create
    @turn = Turn.new(turn_params)

    respond_to do |format|
      if @turn.save
        format.html { redirect_to turn_url(@turn), notice: "Turn was successfully created." }
        format.json { render :show, status: :created, location: @turn }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /turns/1 or /turns/1.json
  def update
    respond_to do |format|
      if @turn.update(turn_params)
        format.html { redirect_to turn_url(@turn), notice: "Turn was successfully updated." }
        format.json { render :show, status: :ok, location: @turn }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turns/1 or /turns/1.json
  def destroy
    @turn.destroy

    respond_to do |format|
      format.html { redirect_to turns_url, notice: "Turn was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def process_turn
    errors = [] # Initialize an empty array to store any errors
  
    begin
      stadium_upgrades(params[:week])
      property_upgrades(params[:week])
      player_upgrades(params[:week])
      coach_upgrades(params[:week])
      increment_upgrades
  
      notice = "Processes ran successfully."
    rescue StandardError => e
      errors << "Error occurred during processing: #{e.message}"
      notice = "Errors occurred during processing:\n\n#{errors.join("\n")}"
    end
  
    redirect_to request.referrer, notice: notice
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_turn
      @turn = Turn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def turn_params
      params.require(:turn).permit(:week, :club, :var1, :var2, :var3)
    end
end
