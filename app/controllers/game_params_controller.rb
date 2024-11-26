class GameParamsController < ApplicationController
  before_action :set_game_param, only: %i[show edit update destroy]

  # GET /game_params or /game_params.json
  def index
    @game_params = GameParam.all
  end

  # GET /game_params/1 or /game_params/1.json
  def show; end

  # GET /game_params/new
  def new
    @game_param = GameParam.new
  end

  # GET /game_params/1/edit
  def edit; end

  # POST /game_params or /game_params.json
  def create
    @game_param = GameParam.new(game_param_params)

    respond_to do |format|
      if @game_param.save
        format.html { redirect_to game_param_url(@game_param), notice: "Game param was successfully created." }
        format.json { render :show, status: :created, location: @game_param }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game_param.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_params/1 or /game_params/1.json
  def update
    respond_to do |format|
      if @game_param.update(game_param_params)
        format.html { redirect_to game_param_url(@game_param), notice: "Game param was successfully updated." }
        format.json { render :show, status: :ok, location: @game_param }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game_param.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_params/1 or /game_params/1.json
  def destroy
    @game_param.destroy

    respond_to do |format|
      format.html { redirect_to game_params_url, notice: "Game param was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_waiting_list
    @game_param = GameParam.first
    @game_param.waiting_list = !@game_param.waiting_list
    @game_param.save
    redirect_to turns_gm_admin_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game_param
    @game_param = GameParam.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def game_param_params
    params.require(:game_param).permit(:chance_factor, :midfield_on_attack)
  end
end
