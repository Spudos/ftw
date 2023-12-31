module PlayersHelper
  def total_goals(player_id)
    pl_stats = PlStat.where(player_id: player_id, goal: true)
    pl_stats.sum(:goals)
  end

  def total_assists(player_id)
    pl_stats = PlStat.where(player_id: player_id, assist: true)
    pl_stats.sum(:assists)
  end
end
