class Player::TopPerformance
  attr_reader :league, :position, :detail

  def initialize(league, position, detail)
    @league = league
    @position = position
    @detail = detail
  end

  def process
    top_performance
  end

  private

  def top_performance
    if position == 'all'
      players = player_data.map do |player|
        unless player.club.league == league
          next
        end
        {
          id: player.id,
          name: player.name,
          club: player.club.name,
          position: (player.position + player.player_position_detail).upcase,
          performance: player.average_performance
        }
      end
    elsif detail == 'none'
      players = player_data.where(position: position).map do |player|
        unless player.club.league == league
          next
        end
        {
          id: player.id,
          name: player.name,
          club: player.club.name,
          position: (player.position + player.player_position_detail).upcase,
          performance: player.average_performance
        }
      end
    else
      players = player_data.where(position: position, player_position_detail: detail).map do |player|
        unless player.club.league == league
          next
        end
        {
          id: player.id,
          name: player.name,
          club: player.club.name,
          position: (player.position + player.player_position_detail).upcase,
          performance: player.average_performance
        }
      end
    end

    players.compact!

    players.sort_by! { |player| -player[:performance] }

    top_perf_players = players.take(10)

    return top_perf_players
  end

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end
end
