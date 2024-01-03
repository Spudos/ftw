class PlayersController < ApplicationController
  include PlayersHelper
  include PlayersPotUpdateHelper

  before_action :set_player
  def index
    @clubs = Player.distinct.pluck(:club)
    @players = Player.all
  end

  def show
    column = params[:sort_column]
    direction = params[:sort_direction]
    criteria = params[:sort_criteria]

    @players = Player.all

    @sort1 = player_view.sort_by! { |player| player[column.to_sym] }
    @sort2 = direction == 'desc' ? @sort1.reverse! : @sort1

    if criteria == ""
      @sorted = @sort2
    else
      @sorted = @sort2.select do |record|
        if record[column.to_sym].is_a?(String)
          record[column.to_sym].include?(criteria)
        else
          record[column.to_sym] == (criteria.to_i)
        end
      end
    end
  end

  def new
    @player = Player.new
  end

  def edit
  end

  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to players_url(@player), notice: "Player was successfully created." }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to players_url, notice: "Player was successfully updated." }
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
      format.html { redirect_to players_url, notice: "Player was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def pot_update
    update_pot_for_gkp
    update_pot_for_dfc
    update_pot_for_mid
    update_pot_for_att
  end

  private

  def set_player
    @player = Player.find_by(id: params[:id])
  end

  def player_params
    params.require(:player).permit(:name, :age, :nationality, :pos, :pa, :co, :ta, :ru, :dr, :df, :of, :fl, :st, :cr, :cons, :fit, :club, :pot_pa, :pot_co, :pot_ta, :pot_ru, :pot_dr, :pot_df, :pot_of, :pot_fl, :pot_st, :pot_cr)
  end
end
