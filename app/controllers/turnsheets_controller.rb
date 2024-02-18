class TurnsheetsController < ApplicationController
  before_action :set_turnsheet, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /turnsheets or /turnsheets.json
  def index
    @turnsheets = Turnsheet.all
  end

  # GET /turnsheets/1 or /turnsheets/1.json
  def show
    authorize @turnsheet
  end

  # GET /turnsheets/new
  def new
    @turnsheet = Turnsheet.new
    authorize @turnsheet
    @club = Club.find_by(manager_email: current_user.email)
    players = @club&.players

    @selection = players.map(&:player_selection_information)
  end

  # GET /turnsheets/1/edit
  def edit
  end

  # POST /turnsheets or /turnsheets.json
  def create
    @turnsheet = Turnsheet.new(turnsheet_params)
    authorize @turnsheet

    respond_to do |format|
      if @turnsheet.save
        format.html { redirect_to request.referrer, notice: 'Turnsheet was successfully created.' }
        format.json { render :show, status: :created, location: @turnsheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turnsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /turnsheets/1 or /turnsheets/1.json
  def update
    respond_to do |format|
      if @turnsheet.update(turnsheet_params)
        format.html { redirect_to request.referrer, notice: 'Turnsheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @turnsheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turnsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turnsheets/1 or /turnsheets/1.json
  def destroy
    @turnsheet = Turnsheets.find(params[:id])
    authorize @turnsheet

    if @turnsheet.destroy
      # Successful deletion
      redirect_to turnsheets_path, notice: 'Turnsheet was successfully deleted.'
    else
      # Error occurred during deletion
      Rails.logger.error("Error deleting turnsheet: #{@turnsheet.errors}")
      redirect_to turnsheets_path, alert: 'Error deleting turnsheet.'
    end
  end

  def process_turnsheet
    turnsheet = Turnsheet.new
    if turnsheet.process_turnsheet
      redirect_to turnsheets_path, notice: 'Turnsheets processed successfully.'
    else
      redirect_to turnsheets_path, alert: "Error processing turnsheets: #{result.join(', ')}"
    end
  end

  private

  def set_turnsheet
    @turnsheet = Turnsheet.find(params[:id])
  end

  def turnsheet_params
    params.require(:turnsheet).permit!
  end
end
