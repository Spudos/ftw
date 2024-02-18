class TurnsController < ApplicationController
  rescue_from StandardError, with: :handle_error
  before_action :set_turn, only: %i[ show edit update destroy ]

  def index
    @turns = Turn.all
    @premier_completed = (Match.where(week_number: params[:week], competition: 'Premier League')).count
    @championship_completed = (Match.where(week_number: params[:week], competition: 'Chamnpionship')).count
    @cup_completed = (Match.where(week_number: params[:week], competition: 'Cup')).count
    @friendlies_completed = (Match.where(week_number: params[:week], competition: 'Friendly')).count
    @games_completed = (Match.where(week_number: params[:week])).count
  end

  def show
  end

  def new
    @turn = Turn.new
  end

  def edit
  end

  def create
    @turn = Turn.new(turn_params)

    respond_to do |format|
      if @turn.save
        format.html { redirect_to turns_path, notice: 'Turn was successfully created.' }
        format.json { render :show, status: :created, location: @turn }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turn.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @turn.update(turn_params)
        format.html { redirect_to turns_path, notice: 'Turn was successfully updated.' }
        format.json { render :show, status: :ok, location: @turn }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turn.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @turn.destroy

    respond_to do |format|
      format.html { redirect_to turns_url, notice: 'Turn was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def process_turn
    errors = []

    begin
      turn = Turn.new
      turn.process_turn_actions(params)

      notice = 'Turn actions ran successfully.'
    rescue StandardError => e
      errors << "Error occurred during processing: #{e.message}"
      notice = "Errors occurred during processing:\n\n#{errors.join("\n")}"
    end

    redirect_to request.referrer, notice: notice
  end

  def process_player_updates
    errors = []

    begin
      turn = Turn.new
      turn.process_player_updates(params)

      notice = 'Player updates ran successfully.'
    rescue StandardError => e
      errors << "Error occurred during processing: #{e.message}"
      notice = "Errors occurred during processing:\n\n#{errors.join("\n")}"
    end

    redirect_to request.referrer, notice: notice
  end

  private

  def set_turn
    @turn = Turn.find(params[:id])
  end

  def turn_params
    params.require(:turn).permit!
  end

  def handle_error(exception)
    redirect_to turns_path, alert: exception.message
  end
end
