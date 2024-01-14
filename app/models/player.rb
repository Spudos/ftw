class Player < ApplicationRecord
  has_one :pl_stat
  has_many :pl_match

  def total_skill
    if position == 'gkp'
      base_skill + gkp_skill
    elsif position == 'dfc'
      base_skill + dfc_skill
    elsif position == 'mid'
      base_skill + mid_skill
    else
      base_skill + att_skill
    end
  end

  def id_name_with_position_and_skill
    "#{id} #{name} - #{position} (Skill: #{total_skill})"
  end

  def base_skill
    passing + control + tackling + running + shooting + dribbling + defensive_heading + offensive_heading + flair + strength + creativity
  end

  def gkp_skill
    passing + control + tackling + shooting + offensive_heading + strength
  end 

  def dfc_skill
    control + tackling + running + defensive_heading + strength + creativity
  end

  def mid_skill
    passing + control + shooting + dribbling + flair + creativity
  end

  def att_skill
    control + running + shooting + dribbling + offensive_heading + flair
  end

  def self.compile_player_view
    players = Player.all.map do |player|
      info = {
      id: player.id,
      name: player.name,
      age: player.age,
      club: player.club,
      nationality: player.nationality,
      position: (player.position + player.player_position_detail).upcase,
      total_skill: player.total_skill,
      played: PlayerMatchData.where(player_id: player.id).count,
      goals: GoalsAndAssistsByMatch.where(scorer: player.id).count(:scorer),
      assists: GoalsAndAssistsByMatch.where(assist: player.id).count(:assist),
      average_match_performance: PlayerMatchData.where(player_id: player.id).average(:match_performance).to_i
      }
    end
  end

  def self.compile_top_total_skill_view
    players = Player.all.map do |player|
      info = {
        id: player.id,
        name: player.name,
        club: player.club,
        position: (player.position + player.player_position_detail).upcase,
        total_skill: player.total_skill
      }
    end

    # Sort players based on total skill in descending order
    players.sort_by! { |player| -player[:total_skill] }

    # Select the top 10 players
    top_skill_players = players.take(10)

    return top_skill_players
  end

  def self.compile_top_performance_view
    players = Player.all.map do |player|
      info = {
        id: player.id,
        name: player.name,
        club: player.club,
        position: (player.position + player.player_position_detail).upcase,
        average_match_performance: PlayerMatchData.where(player_id: player.id).average(:match_performance).to_i
      }
    end

    # Sort players based on total skill in descending order
    players.sort_by! { |player| -player[:average_match_performance] }

    # Select the top 10 players
    top_perf_players = players.take(10)

    return top_perf_players
  end

  def self.compile_top_goals_view
    players = Player.all.map do |player|
      info = {
        id: player.id,
        name: player.name,
        club: player.club,
        position: (player.position + player.player_position_detail).upcase,
        goals: GoalsAndAssistsByMatch.where(scorer: player.id).count(:scorer),
      }
    end

    # Sort players based on total skill in descending order
    players.sort_by! { |player| -player[:goals] }

    # Select the top 10 players
    top_goals_players = players.take(10)

    return top_goals_players
  end

  def self.compile_top_assists_view
    players = Player.all.map do |player|
      info = {
        id: player.id,
        name: player.name,
        club: player.club,
        position: (player.position + player.player_position_detail).upcase,
        assists: GoalsAndAssistsByMatch.where(assist: player.id).count(:assist)
      }
    end

    # Sort players based on total skill in descending order
    players.sort_by! { |player| -player[:assists] }

    # Select the top 10 players
    top_assists_players = players.take(10)

    return top_assists_players
  end

  def match_performance(player)
    if player.position == 'gkp'
      (player.gkp_skill * player.fitness / 100) + player.calc_pl_performance_random(player)
    elsif player.position == 'dfc'
      (player.dfc_skill * player.fitness / 100) + player.calc_pl_performance_random(player)
    elsif player.position == 'mid'
      (player.mid_skill * player.fitness / 100) + player.calc_pl_performance_random(player)
    else
      (player.att_skill * player.fitness / 100) + player.calc_pl_performance_random(player)
    end
  end

  def calc_pl_performance_random(player)
    consistency = player.consistency
    random_number = rand(-consistency..consistency)
  end
end
