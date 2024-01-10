module MatchesSquadHelper
  def sqd_pl(sqd)
    sqd.map do |player|
      @pl_match_performance = player.match_performance(player)
      
      tactic = Tactic.find_by(abbreviation: player.club)&.tactics

      pl_match = PlMatch.create(
        player_id: player.id,
        match_id: @match_id,
        tactic: tactic,
        player_position: player.position,
        player_position_detail: player.player_position_detail,
        match_performance: @pl_match_performance
      )

      tactic_adjustment(pl_match)

      {
        match_id: @match_id,
        id: player.id,
        club: player.club,
        name: player.name,
        tactic: tactic,
        pos: player.position,
        player_position_detail: player.player_position_detail,
        total_skill: player.total_skill,
        match_performance: @pl_match_performance
      }
    end
  end

  def tm_total(sqd_pl)

    stadium_effect(sqd_pl.first[:club])

    dfc = 0 + @stadium_effect
    mid = 0 + @stadium_effect
    att = 0 + @stadium_effect

    sqd_pl.each do |player|
      case player[:pos]
      when 'gkp', 'dfc'
        dfc += player[:match_performance]
      when 'mid'
        mid += player[:match_performance]
      else
        att += player[:match_performance]
      end
    end

    [dfc, mid, att]
  end

  def stadium_effect(club)
    if club == @club_home
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
    case player.position
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

  def tactic_adjustment(pl_match)
    # tactic name       dfc  mid  att  l,r  c
    # 1      passing    -5  +10  -0    0    0
    # 2      defensive  +15 -5   -10   0    0
    # 3      Attacking  -10 +5   +15   0    0
    # 4      Wide        0   0    0   +10  -10
    # 5      Narrow      0   0    0   -10  +10
    # 6      Direct     +5  -5   +5    0    0

    if pl_match.player_position_detail == 'c'
      pl_match.match_performance -= 10 if pl_match.tactic == 4
      pl_match.match_performance += 10 if pl_match.tactic == 5
    elsif pl_match.player_position_detail == 'r' || pl_match.player_position_detail == 'r'
     pl_match.match_performance += 10 if pl_match.tactic == 4
      pl_match.match_performance -= 10 if pl_match.tactic == 5
    end 

      if pl_match.player_position == 'dfc'
        pl_match.match_performance -= 5 if pl_match.tactic == 1
        pl_match.match_performance += 15 if pl_match.tactic == 2
        pl_match.match_performance -= 10 if pl_match.tactic == 3
        pl_match.match_performance += 5 if pl_match.tactic == 6
      elsif pl_match.player_position == 'mid'
        pl_match.match_performance += 15 if pl_match.tactic == 1
        pl_match.match_performance -= 10 if pl_match.tactic == 2
        pl_match.match_performance += 15 if pl_match.tactic == 3
        pl_match.match_performance -= 5 if pl_match.tactic == 6
      elsif pl_match.player_position == 'att'
        pl_match.match_performance -= 5 if pl_match.tactic == 1
        pl_match.match_performance -= 10 if pl_match.tactic == 2
        pl_match.match_performance += 10 if pl_match.tactic == 3
        pl_match.match_performance += 5 if pl_match.tactic == 6
      end
  end
end