class TurnsController < ApplicationController
  rescue_from StandardError, with: :handle_error
  before_action :set_turn, only: %i[show edit update destroy]

  def index
    @games_completed = Match.where(week_number: params[:week])
                            .pluck(:competition)
                            .group_by(&:itself)
                            .transform_values(&:count)
    @games_scheduled = Fixture.where(week_number: params[:week])
                              .pluck(:comp)
                              .group_by(&:itself)
                              .transform_values(&:count)

    @turnsheets_processed = Turnsheet.where(week: params[:week])
                                     .where.not(processed: nil)
                                     .count
    @turnsheets_submitted = Turnsheet.where(week: params[:week])
                                     .count

    @turn_actions_processed = TurnActions.where(week: params[:week])
                                         .where.not(date_completed: nil)
                                         .count
    @turn_actions_submitted = TurnActions.where(week: params[:week]).count

    @last_turn_processed = Message.maximum(:week)

    @errors = Error.all.sort_by(&:created_at).reverse

    @turn_actions = TurnActions.where(week: params[:week]).order(:club_id)

    @turn = Turn.find_by(week: params[:week])

    @auto_selection = Turn.find_by(week: params[:week])&.auto_selections
  end

  def show; end

  def new
    @turn = Turn.new
  end

  def edit; end

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

  def gm_admin
    @feedback = Feedback.where(outstanding: true)
  end

  def process_pre_turn_admin
    PreTurnAdminJob.perform_later(params[:week])

    notice = 'The pre turn admin job has been sent for processing.'
    redirect_to request.referrer, notice:
  end

  def process_matches
    MatchesJob.perform_later(params[:selected_week])

    notice = 'The run matches job has been sent for processing.'
    redirect_to request.referrer, notice:
  end

  def process_end_of_turn
    EndOfTurnJob.perform_later(params[:week])

    notice = 'The end of turn job has been sent for processing.'
    redirect_to request.referrer, notice:
  end

  private

  def set_turn
    @turn = TurnActions.find_by(id: params[:id])
  end

  def turn_params
    params.require(:turn).permit!
  end

  def handle_error(exception)
    redirect_to turns_path, alert: exception.message
  end
end
