class ClubsController < ApplicationController
  before_action :set_club, except: [:index, :new]
  before_action :set_club_theme

  def index
    @clubs = Club.all
  end

  def show
    @club = Club.find_by(id: params[:id])
    @selection = Selection.where(club_id: params[:id])
    @players = Player.where(club: params[:id])
    @club_matches = Match.where('home_team = ? OR away_team = ?', params[:id], params[:id])
    @message = Message.where(club: params[:id])
    @tactic = Tactic.find_by(club_id: params[:id])
  end

  def new
    @club = Club.new
  end

  def edit
    @club = Club.find_by(id: params[:id])
  end

  def create
    @club = Club.new(club_params)

    respond_to do |format|
      if @club.save
        format.html { redirect_to clubs_path, notice: "Club was successfully created." }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @club = Club.find_by(id: params[:id])
    respond_to do |format|
      if @club.update(club_params)
        format.html { redirect_to clubs_path, notice: "Club was successfully updated." }
        format.json { render :show, status: :ok, location: @club }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @club.destroy

    respond_to do |format|
      format.html { redirect_to clubs_url, notice: "Club was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def club_view
    render 'clubs/manager/club_view'
  end

  def finance
    render 'clubs/manager/finance'
  end

  def messages
    render 'clubs/manager/mesages_new'
  end

  def messages_finance
    render 'clubs/manager/mesages_finance'
  end

  def first_team
    render 'clubs/manager/first_team'
  end

  def players_contract
    render 'clubs/manager/players_contract'
  end

  def team_statistics
    render 'clubs/manager/team_statistics'
  end

  def team_selection
    render 'clubs/manager/team_selection'
  end

  def results
    render 'clubs/manager/results'
  end

  def fixtures
    render 'clubs/manager/fixtures'
  end

  def history
    render 'clubs/manager/history'
  end

  def messages
    render 'clubs/manager/messages'
  end

  private

  def set_club
    highest_week = Message.maximum(:week)
    @club = Club.find_by(manager_email: current_user[:email])
    @club_matches = Match.where('home_team = ? OR away_team = ?', @club.id, @club.id)
    @club_fixtures = Fixture.where('home= ? OR away = ?', @club.id, @club.id)
    @messages = Message.where(club_id: Club.find_by(manager_email: current_user[:email])&.id)
    @messages_new = Message.where(club_id: Club.find_by(manager_email: current_user[:email])&.id).where(var2: nil).where(week: highest_week)
    @messages_finance = Message.where(club_id: Club.find_by(manager_email: current_user[:email])&.id).where(week: highest_week).where.not(var2: nil)
    @finance_items = Club.new.finance_items(@club.id)
  end

  def set_club_theme
    @primary = Club.find_by(manager_email: current_user[:email]).color_primary
    @secondary = Club.find_by(manager_email: current_user[:email]).color_secondary
  end

  def club_params
    params.require(:club).permit!
  end
end
