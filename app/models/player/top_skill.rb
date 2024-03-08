class Player::TopSkill
  attr_reader :league, :position, :detail

  def initialize(league, position, detail)
    @league = league
    @position = position
    @detail = detail
  end

  def process
    top_skill
  end

  private

  def top_skill
    if position == 'all'
      players = player_data.map do |player|
        unless player.club.league == league
          next
        end
        info = {
          id: player.id,
          name: player.name,
          club: player.club.name,
          position: (player.position + player.player_position_detail).upcase,
          total_skill: player.total_skill
        }
      end
    elsif detail == 'none'
      players = player_data.where(position:).map do |player|
        unless player.club.league == league
          next
        end
        info = {
          id: player.id,
          name: player.name,
          club: player.club.name,
          position: (player.position + player.player_position_detail).upcase,
          total_skill: player.total_skill
        }
      end
    else
      players = player_data.where(position:, player_position_detail: detail).map do |player|
        unless player.club.league == league
          next
        end
        info = {
          id: player.id,
          name: player.name,
          club: player.club.name,
          position: (player.position + player.player_position_detail).upcase,
          total_skill: player.total_skill
        }
      end
    end

    players.compact!

    players.sort_by! { |player| -player[:total_skill] }

    top_skill_players = players.take(10)

    return top_skill_players
  end

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end
end
