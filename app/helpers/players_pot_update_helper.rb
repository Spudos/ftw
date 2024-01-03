module PlayersPotUpdateHelper

  def player_view
    players_data = []

    @players.each do |player|
      player_data = {
      id: player.id,
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

  def update_pot_for_gkp
    players = Player.where(pos: 'gkp')
    players.each do |player|
      updates = {
        pot_pa: player.pa + rand(1..10),
        pot_co: player.co + rand(1..10),
        pot_ta: player.ta + rand(1..10),
        pot_ru: player.ru + rand(1..5),
        pot_sh: player.sh + rand(1..10),
        pot_dr: player.dr + rand(1..5),
        pot_df: player.df + rand(1..5),
        pot_of: player.of + rand(1..10),
        pot_fl: player.fl + rand(1..5),
        pot_st: player.st + rand(1..10),
        pot_cr: player.cr + rand(1..5)
      }
      player.update(updates)
    end
  end

  def update_pot_for_dfc
    players = Player.where(pos: 'dfc')
    players.each do |player|
      updates = {
        pot_pa: player.pa + rand(1..5),
        pot_co: player.co + rand(1..10),
        pot_ta: player.ta + rand(1..10),
        pot_ru: player.ru + rand(1..10),
        pot_sh: player.sh + rand(1..3),
        pot_dr: player.dr + rand(1..2),
        pot_df: player.df + rand(1..10),
        pot_of: player.of + rand(1..5),
        pot_fl: player.fl + rand(1..2),
        pot_st: player.st + rand(1..10),
        pot_cr: player.cr + rand(1..10)
      }
      player.update(updates)
    end
  end

  def update_pot_for_mid
    players = Player.where(pos: 'mid')
    players.each do |player|
      updates = {
        pot_pa: player.pa + rand(1..10),
        pot_co: player.co + rand(1..10),
        pot_ta: player.ta + rand(1..3),
        pot_ru: player.ru + rand(1..5),
        pot_sh: player.sh + rand(1..10),
        pot_dr: player.dr + rand(1..10),
        pot_df: player.df + rand(1..3),
        pot_of: player.of + rand(1..3),
        pot_fl: player.fl + rand(1..10),
        pot_st: player.st + rand(1..5),
        pot_cr: player.cr + rand(1..10)
      }
      player.update(updates)
    end
  end

  def update_pot_for_att
    players = Player.where(pos: 'att')
    players.each do |player|
      updates = {
        pot_pa: player.pa + rand(1..5),
        pot_co: player.co + rand(1..10),
        pot_ta: player.ta + rand(1..3),
        pot_ru: player.ru + rand(1..10),
        pot_sh: player.sh + rand(1..10),
        pot_dr: player.dr + rand(1..10),
        pot_df: player.df + rand(1..3),
        pot_of: player.of + rand(1..10),
        pot_fl: player.fl + rand(1..10),
        pot_st: player.st + rand(1..5),
        pot_cr: player.cr + rand(1..5)
      }
      player.update(updates)
    end
  end
end
