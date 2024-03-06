class PlayersController < ApplicationController
  before_action :set_player

  def index
    @clubs = Player.distinct.pluck(:club)
    @players = Player.all
  end

  def show
    @player = Player.find_by(id: params[:format])
    @highest_performance = Player.order(average_performance: :desc).first&.average_performance
    @high_performance = Performance.where(player_id: params[:format]).maximum(:match_performance)
    @low_performance = Performance.where(player_id: params[:format]).minimum(:match_performance)
    @performance_data = Performance.where(player_id: params[:format]).pluck(:match_id, :match_performance)
  end

  def player_view
    @players = Player.compile_player_view

    @sort1 = @players.sort_by { |player| player[params[:sort_column].to_sym] }
    @sort2 = params[:sort_direction] == 'desc' ? @sort1.reverse! : @sort1

    if params[:sort_criteria] == ""
      @sort3 = @sort2
    else
      @sort3 = @sort2.select do |record|
        if record[params[:sort_column].to_sym].is_a?(String)
          record[params[:sort_column].to_sym].include?(params[:sort_criteria])
        else
          record[params[:sort_column].to_sym] == (params[:sort_criteria].to_i)
        end
      end
    end

    @sorted = @sort3.to_a

    if @sorted.nil?
      @paginated_players = []
    else
      @paginated_players = WillPaginate::Collection.create(params[:page], 20, @players.length) do |pager|
        pager.replace(@sorted[pager.offset, pager.per_page])
      end
    end
  end

  def unmanaged_players
    @unmanaged = Player.where(club_id: 242)
  end

  def listed_players
    @listed = Player.where(listed: true)
  end

  def new
    @player = Player.new
  end

  def edit; end

  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to players_path, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @player = Player.find(player_params[:id])
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to request.referrer, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_player
    @player = Player.find_by(id: params[:id])
  end

  def player_params
    params.require(:player).permit!
  end
end
