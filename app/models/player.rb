class Player < ApplicationRecord
  has_many :performances
  has_many :goals, foreign_key: :scorer_id
  has_many :assists, foreign_key: :assist_id, class_name: 'Goal'
  belongs_to :club

  def total_skill_calc
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

  def self.player_value_update
    objects = [Turn::Engines::Value,
               Turn::Engines::Wages,
               Turn::Engines::TotalSkill]

    week = Message.maximum(:week) || 0

    player_data.in_batches do |batch|
      players = batch.load

      objects.each do |object|
        players = object.new(players, week).process
      end

      attributes = players.to_a.map(&:as_json)
      Player.upsert_all(attributes)
    end
  end

  def player_selection_information
    {
      id:,
      name:,
      position: (position + player_position_detail).upcase,
      ts: total_skill,
      fitness:
    }
  end

  def base_skill
    if passing.present? && control.present? &&
       tackling.present? && running.present? &&
       shooting.present? && dribbling.present? &&
       defensive_heading.present? && offensive_heading.present? &&
       flair.present? && strength.present? &&
       creativity.present?

      passing + control + tackling + running +
        shooting + dribbling + defensive_heading +
        offensive_heading + flair + strength + creativity
    else
      0
    end
  end

  def gkp_skill
    passing + control + tackling +
      shooting + offensive_heading + strength
  end

  def dfc_skill
    control + tackling + running +
      defensive_heading + strength + creativity
  end

  def mid_skill
    passing + control + shooting +
      dribbling + flair + creativity
  end

  def att_skill
    control + running + shooting +
      dribbling + offensive_heading + flair
  end

  def self.player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end

  def self.compile_player_view
    player_data.map do |player|
      {
        id: player.id,
        name: player.name,
        age: player.age,
        club: player.club.name,
        nationality: player.nationality,
        position: (player.position + player.player_position_detail).upcase,
        total_skill: player.total_skill,
        played: player.games_played,
        goals: player.total_goals,
        assists: player.total_assists,
        average_match_performance: player.average_performance
      }
    end
  end

  def self.compile_top_total_skill_view(league)
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

    players.compact!

    players.sort_by! { |player| -player[:total_skill] }

    return players
  end

  def self.compile_top_performance_view(league)
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

    players.compact!

    players.sort_by! { |player| -player[:performance] }

    return players
  end

  def self.compile_top_goals_view(league)
    players = player_data.map do |player|
      unless player.club.league == league
        next
      end
      {
        id: player.id,
        name: player.name,
        club: player.club.name,
        position: (player.position + player.player_position_detail).upcase,
        goals: player.total_goals
      }
    end

    players.compact!

    players.sort_by! { |player| -player[:goals] }

    top_goals_players = players.take(10)

    return top_goals_players
  end

  def self.compile_top_assists_view(league)
    players = player_data.map do |player|
      unless player.club.league == league
        next
      end
      {
        id: player.id,
        name: player.name,
        club: player.club.name,
        position: (player.position + player.player_position_detail).upcase,
        assists: player.total_assists
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
