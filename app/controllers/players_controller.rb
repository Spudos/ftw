class PlayersController < ApplicationController
  def index
    @clubs = Player.distinct.pluck(:club)
    @players = Player.all
    @p_players = Player.paginate(page: params[:page], per_page: 100)
  end

  def total_goals(player_id)
    pl_stats = PlStat.where(player_id: player_id, goal: true)
    pl_stats.sum(:goals)
  end

  def total_assists(player_id)
    pl_stats = PlStat.where(player_id: player_id, assist: true)
    pl_stats.sum(:assists)
  end
end
