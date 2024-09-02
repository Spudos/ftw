class SquadActionsController < ApplicationController
  before_action :set_squad_action, only: %i[ show edit update destroy ]

  # GET /squad_actions or /squad_actions.json
  def index
    @squad_actions = SquadAction.all
  end

  # GET /squad_actions/1 or /squad_actions/1.json
  def show
  end

  # GET /squad_actions/new
  def new
    @squad_action = SquadAction.new
  end

  # GET /squad_actions/1/edit
  def edit
  end

  # POST /squad_actions or /squad_actions.json
  def create
    @squad_action = SquadAction.new(squad_action_params)

    respond_to do |format|
      if @squad_action.save
        format.html { redirect_to squad_action_url(@squad_action), notice: "Squad action was successfully created." }
        format.json { render :show, status: :created, location: @squad_action }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @squad_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /squad_actions/1 or /squad_actions/1.json
  def update
    respond_to do |format|
      if @squad_action.update(squad_action_params)
        format.html { redirect_to squad_action_url(@squad_action), notice: "Squad action was successfully updated." }
        format.json { render :show, status: :ok, location: @squad_action }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @squad_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /squad_actions/1 or /squad_actions/1.json
  def destroy
    @squad_action.destroy

    respond_to do |format|
      format.html { redirect_to squad_actions_url, notice: "Squad action was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_squad_action
      @squad_action = SquadAction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def squad_action_params
      params.fetch(:squad_action, {})
    end
end
