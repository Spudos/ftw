module MatchesSquadHelper
  def sqd_pl(sqd)
    sqd.map do |player|
      @pl_match_perf = player.match_perf(player)

      pl_match = PlMatch.create(
        player_id: player.id,
        match_id: @match_id,
        match_perf: @pl_match_perf
      )

      {
        match_id: @match_id,
        id: player.id,
        club: player.club,
        name: player.name,
        pos: player.pos,
        total_skill: player.total_skill,
        match_perf: @pl_match_perf
      }
    end
  end

  def tm_tot(sqd_pl)

    stadium_effect(sqd_pl.first[:club])

    dfc = 0 + @stadium_effect
    mid = 0 + @stadium_effect
    att = 0 + @stadium_effect

    sqd_pl.each do |player|
      case player[:pos]
      when 'gkp', 'dfc'
        dfc += player[:match_perf]
      when 'mid'
        mid += player[:match_perf]
      else
        att += player[:match_perf]
      end
    end

    [dfc, mid, att]
  end

  def stadium_effect(club)
    if club == @club_hm
      club = Club.find_by(abbreviation: club)
      stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity
      calc_stadium_effect(stadium_size)
    else
      @stadium_effect = 0
    end
  end

  def calc_stadium_effect(stadium_size)
    if stadium_size <= 10000
      @stadium_effect = 0
    elsif stadium_size <= 20000
      @stadium_effect = 2
    elsif stadium_size <= 30000
      @stadium_effect = 3
    elsif stadium_size <= 40000
      @stadium_effect = 4
    elsif stadium_size <= 50000
      @stadium_effect = 5
    elsif stadium_size <= 60000
      @stadium_effect = 6   
    elsif stadium_size <= 70000
      @stadium_effect = 7
    else
      @stadium_effect = 10
    end
  end

  def pos_skl(player)
    case player.pos
    when 'gkp'
      player.gkp_skill
    when 'dfc'
      player.dfc_skill
    when 'mid'
      player.mid_skill
    else
      player.att_skill
    end
  end
end