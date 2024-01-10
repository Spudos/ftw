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
