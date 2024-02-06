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

  def player_selection_information
    "#{id} #{name} - #{position.upcase}#{player_position_detail.upcase} (Skill: #{total_skill}) (Fitness: #{fitness})"
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

  def self.compile_top_total_skill_view(league, position)
    if position == 'all'
      players = Player.all.map do |player|
        unless Club.find_by(abbreviation: player.club)&.league == league
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
    else
      players = Player.where(position: position).map do |player|
        unless Club.find_by(abbreviation: player.club)&.league == league
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
    end

    players.compact!

    players.sort_by! { |player| -player[:total_skill] }

    top_skill_players = players.take(20)

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

    top_perf_players = players.take(20)

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

    top_goals_players = players.take(20)

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

    top_assists_players = players.take(20)

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

#------------------------------------------------------------------------------
# Player
#
# Name                        SQL Type             Null    Primary Default
# --------------------------- -------------------- ------- ------- ----------
# id                          INTEGER              false   true              
# name                        varchar              true    false             
# age                         INTEGER              true    false             
# nationality                 varchar              true    false             
# position                    varchar              true    false             
# passing                     INTEGER              true    false             
# control                     INTEGER              true    false             
# tackling                    INTEGER              true    false             
# running                     INTEGER              true    false             
# shooting                    INTEGER              true    false             
# dribbling                   INTEGER              true    false             
# defensive_heading           INTEGER              true    false             
# offensive_heading           INTEGER              true    false             
# flair                       INTEGER              true    false             
# strength                    INTEGER              true    false             
# creativity                  INTEGER              true    false             
# fitness                     INTEGER              true    false             
# created_at                  datetime(6)          false   false             
# updated_at                  datetime(6)          false   false             
# club                        varchar              true    false             
# consistency                 INTEGER              true    false             
# potential_passing           INTEGER              true    false             
# potential_control           INTEGER              true    false             
# potential_tackling          INTEGER              true    false             
# potential_running           INTEGER              true    false             
# potential_shooting          INTEGER              true    false             
# potential_dribbling         INTEGER              true    false             
# potential_defensive_heading INTEGER              true    false             
# potential_offensive_heading INTEGER              true    false             
# potential_flair             INTEGER              true    false             
# potential_strength          INTEGER              true    false             
# potential_creativity        INTEGER              true    false             
# player_position_detail      varchar              true    false             
# blend                       INTEGER              true    false             
# contract                    INTEGER              true    false   24        
# star                        INTEGER              true    false             
#
#------------------------------------------------------------------------------
