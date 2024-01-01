class PlayersController < ApplicationController
  include PlayersHelper

  def index
    @clubs = Player.distinct.pluck(:club)
    @players = Player.all
  end

  def total_goals(player_id)
    pl_stats = PlStat.where(player_id: player_id, goal: true)
    pl_stats.sum(:goals)
  end

  def total_assists(player_id)
    pl_stats = PlStat.where(player_id: player_id, assist: true)
    pl_stats.sum(:assists)
  end

  def show
    column = params[:sort_column]
    direction = params[:sort_direction]
    criteria = params[:sort_criteria]

    @players = Player.all

    @sort1 = player_view.sort_by! { |player| player[column.to_sym] }
    @sort2 = direction == 'desc' ? @sort1.reverse! : @sort1

    if criteria.nil?
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

  private

  def player_view
    players_data = []

    @players.each do |player|
      player_data = {
      name: player.name,
      age: player.age,
      club: player.club,
      nationality: player.nationality,
      position: player.pos,
      total_skill: player.total_skill,
      match_performance_count: PlMatch.where(player_id: player.id).count(:match_perf),
      goal_count: PlStat.where(player_id: player.id, goal: true).count,
      assist_count: PlStat.where(player_id: player.id, assist: true).count,
      average_match_performance: PlMatch.where(player_id: player.id).average(:match_perf).to_i
      }

      players_data << player_data
    end

    players_data
  end
end
