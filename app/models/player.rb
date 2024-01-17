class Player < ApplicationRecord
  has_many :performances
  has_many :goals, foreign_key: :scorer
  has_many :assists, foreign_key: :assist, class_name: 'Goal'

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
    "#{id} #{name} - #{position.upcase}#{player_position_detail.upcase} (Skill: #{total_skill})"
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
    Player.includes(:performances, :goals, :assists).map do |player|
      {
        id: player.id,
        name: player.name,
        age: player.age,
        club: player.club,
        nationality: player.nationality,
        position: (player.position + player.player_position_detail).upcase,
        total_skill: player.total_skill,
        played: player.performances.count,
        goals: player.goals.count,
        assists: player.assists.count,
        average_match_performance: player.performances.average(:match_performance).to_i
      }
    end
  end

  def self.compile_top_total_skill_view(params)
    players = Player.all.map do |player|
      unless Club.find_by(abbreviation: player.club)&.league == params
        next
      end

      info = {
        id: player.id,
        name: player.name,
        club: player.club,
        position: (player.position + player.player_position_detail).upcase,
        total_skill: player.total_skill
      }
    end

    # Remove nil values from the players array
    players.compact!

    # Sort players based on total skill in descending order
    players.sort_by! { |player| -player[:total_skill] }

    # Select the top 10 players
    top_skill_players = players.take(10)

    return top_skill_players
  end

  def self.compile_top_performance_view(params)
    players = Player.includes(:performances, :goals, :assists).map do |player|
      {
        id: player.id,
        name: player.name,
        club: player.club,
        position: (player.position + player.player_position_detail).upcase,
        average_match_performance: player.performances.where(competition: params).average(:match_performance).to_i
      }
    end

    players.compact!

    players.sort_by! { |player| -player[:average_match_performance] }

    top_perf_players = players.take(10)

    return top_perf_players
  end

  def self.compile_top_goals_view(params)
    players = Player.includes(:performances, :goals, :assists).map do |player|
      {
        id: player.id,
        name: player.name,
        club: player.club,
        position: (player.position + player.player_position_detail).upcase,
        goals: player.goals.where(competition: params).count(:scorer_id).to_i
      }
    end

    players.compact!

    players.sort_by! { |player| -player[:goals] }

    top_goals_players = players.take(10)

    return top_goals_players
  end

  def self.compile_top_assists_view(params)
    players = Player.includes(:performances, :goals, :assists).map do |player|
      {
        id: player.id,
        name: player.name,
        club: player.club,
        position: (player.position + player.player_position_detail).upcase,
        assists: player.assists.where(competition: params).count(:assist_id).to_i
      }
    end

    players.compact!

    players.sort_by! { |record| -record[:assists] }

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
