class TurnsheetsController < ApplicationController
  before_action :set_turnsheet, only: %i[ show edit update destroy ]

  # GET /turnsheets or /turnsheets.json
  def index
    @turnsheets = Turnsheet.all
  end

  # GET /turnsheets/1 or /turnsheets/1.json
  def show
  end

  # GET /turnsheets/new
  def new
    @turnsheet = Turnsheet.new
  end

  # GET /turnsheets/1/edit
  def edit
  end

  # POST /turnsheets or /turnsheets.json
  def create
    @turnsheet = Turnsheet.new(turnsheet_params)

    respond_to do |format|
      if @turnsheet.save
        format.html { redirect_to turnsheet_url(@turnsheet), notice: "Turnsheet was successfully created." }
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
        format.html { redirect_to turnsheet_url(@turnsheet), notice: "Turnsheet was successfully updated." }
        format.json { render :show, status: :ok, location: @turnsheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turnsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turnsheets/1 or /turnsheets/1.json
  def destroy
    @turnsheet.destroy

    respond_to do |format|
      format.html { redirect_to turnsheets_url, notice: "Turnsheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_turnsheet
      @turnsheet = Turnsheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def turnsheet_params
      params.require(:turnsheet).permit(:week, :club, :manager, :email)
    end
end
