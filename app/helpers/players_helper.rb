module PlayersHelper
  def total_goals(player_id)
    pl_statistics = PlStat.where(player_id: player_id, goal: true)
    pl_statistics.sum(:goals)
  end

  def total_assists(player_id)
    pl_statistics = PlStat.where(player_id: player_id, assist: true)
    pl_statistics.sum(:assists)
  end
end
