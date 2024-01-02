class TurnsController < ApplicationController
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
    stadium_upgrades(1)
    increment_upgrades
    perform_completed_upgrades
  end

  def stadium_upgrades(week)
    turns = Turn.where("var1 LIKE ?", 'stand%').where(week: week)
  hash = {}

  turns.each do |turn|
    hash[turn.id] = {
      week: turn.week,
      club: turn.club,
      var1: turn.var1,
      var2: turn.var2,
      var3: turn.var3,
      Actioned: turn.date_completed
    }
  end

    bank_adjustment(1, 'alv', 'stand upgrade', 500000)
    add_to_upgrades(1, 'alv', 'north', 2000)
  end

  def bank_adjustment(week, club, reason, amount)
    club_full = Club.find_by(abbreviation: club)

    new_bal = club_full.bank_bal.to_i - amount
    club_full.update(bank_bal: new_bal)

    Messages.create(week:, club:, var1: reason, var2: amount)
  end

  def add_to_upgrades(week, club, stand, seats)
    # add the upgrade to the upgrades table with a to complete of 0
    @upgrade = Upgrades.new
    
    if @upgrade.save
      # Handle successful save
      redirect_to @upgrade, notice: 'Upgrade was successfully created.'
    else
      # Handle save failure
      render :new
    end
  end

  def increment_upgrades
    # increment all items by 1
    # post a message to club messages if the upgrade is not yet complete ie < 6
  end

  def perform_completed_upgrades
    # if upgrade to complete == 6 then change the club actual value and post to club message
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
