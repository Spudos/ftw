class TurnsController < ApplicationController
  rescue_from StandardError, with: :handle_error
  before_action :set_turn, only: %i[show edit update destroy]

  def index
    @turn_actions = TurnActions.all
    @premier_completed = Match.where(week_number: params[:week], competition: 'Premier League').count
    @premier_scheduled = Fixture.where(week_number: params[:week], comp: 'Premier League').count
    @championship_completed = Match.where(week_number: params[:week], competition: 'Championship').count
    @championship_scheduled = Fixture.where(week_number: params[:week], comp: 'Championship').count

    @ligue_1_completed = Match.where(week_number: params[:week], competition: 'Ligue 1').count
    @ligue_1_scheduled = Fixture.where(week_number: params[:week], comp: 'Ligue 1').count
    @ligue_2_completed = Match.where(week_number: params[:week], competition: 'Ligue 2').count
    @ligue_2_scheduled = Fixture.where(week_number: params[:week], comp: 'Ligue 2').count

    @serie_a_completed = Match.where(week_number: params[:week], competition: 'Serie A').count
    @serie_a_scheduled = Fixture.where(week_number: params[:week], comp: 'Serie A').count
    @serie_b_completed = Match.where(week_number: params[:week], competition: 'Serie B').count
    @serie_b_scheduled = Fixture.where(week_number: params[:week], comp: 'Serie B').count

    @bundesliga_1_completed = Match.where(week_number: params[:week], competition: 'Bundesliga 1').count
    @bundesliga_1_scheduled = Fixture.where(week_number: params[:week], comp: 'Bundesliga 1').count
    @bundesliga_2_completed = Match.where(week_number: params[:week], competition: 'Bundesliga 2').count
    @bundesliga_2_scheduled = Fixture.where(week_number: params[:week], comp: 'Bundesliga 2').count

    @la_liga_completed = Match.where(week_number: params[:week], competition: 'La Liga').count
    @la_liga_scheduled = Fixture.where(week_number: params[:week], comp: 'La Liga').count
    @segunda_division_completed = Match.where(week_number: params[:week], competition: 'Segunda Division').count
    @segunda_division_scheduled = Fixture.where(week_number: params[:week], comp: 'Segunda Division').count

    @brasileiro_serie_a_completed = Match.where(week_number: params[:week], competition: 'Brasileiro Serie A').count
    @brasileiro_serie_a_scheduled = Fixture.where(week_number: params[:week], comp: 'Brasileiro Serie A').count
    @brasileiro_serie_b_completed = Match.where(week_number: params[:week], competition: 'Brasileiro Serie B').count
    @brasileiro_serie_b_scheduled = Fixture.where(week_number: params[:week], comp: 'Brasileiro Serie B').count

    @league_cup_completed = Match.where(week_number: params[:week], competition: 'League Cup').count
    @league_cup_scheduled = Fixture.where(week_number: params[:week], comp: 'League Cup').count

    @wcc_completed = Match.where(week_number: params[:week], competition: 'WCC').count
    @wcc_scheduled = Fixture.where(week_number: params[:week], comp: 'WCC').count

    @friendlies_completed = Match.where(week_number: params[:week], competition: 'Friendly').count
    @friendlies_scheduled = Fixture.where(week_number: params[:week], comp: 'Friendly').count

    @games_completed = Match.where(week_number: params[:week]).count
    @games_scheduled = Fixture.where(week_number: params[:week]).count

    @turnsheets_processed = Turnsheet.where(week: params[:week]).where.not(processed: nil).count
    @turnsheets_submitted = Turnsheet.where(week: params[:week]).count

    @turn_actions_processed = TurnActions.where(week: params[:week]).where.not(date_completed: nil).count
    @turn_actions_submitted = TurnActions.where(week: params[:week]).count

    @last_turn_processed = Message.maximum(:week)

    @errors = Error.all.sort_by(&:created_at).reverse

    @turn = Turn.find_by(week: params[:week])
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
