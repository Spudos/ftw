module MatchesInitializersHelper
  def initialize_sqd(fixture)

    @match_id = fixture[:match_id].to_i
    @week_number = fixture[:week_number].to_i
    @club_hm = fixture[:club_hm]
    @club_aw = fixture[:club_aw]

    player_ids_hm = Selection.where(club: @club_hm).pluck(:player_id)
    player_ids_aw = Selection.where(club: @club_aw).pluck(:player_id)

    @sqd_hm = Player.where(id: player_ids_hm)
    @sqd_aw = Player.where(id: player_ids_aw)
  end

  def initialize_sqd_pl
    @sqd_pl_hm = sqd_pl(@sqd_hm)
    @sqd_pl_aw = sqd_pl(@sqd_aw)
  end

  def initialize_tm_tot
    @dfc_hm, @mid_hm, @att_hm = tm_tot(@sqd_pl_hm)
    @dfc_aw, @mid_aw, @att_aw = tm_tot(@sqd_pl_aw)
  end

  def initialize_tm_cha_val
    @aw_mod = (@mid_aw + (@att_aw * 0.50)) + rand(-20..20)
    @hm_mod = (@mid_hm + (@att_hm * 0.50)) + rand(-20..20)
  end

  def initialize_cha?
    @cha_res = cha?
  end

  def initialize_cha_count
    cha_count
  end

  def initialize_cha_on_tar
    cha_on_tar(@att_hm, @att_aw)
  end

  def initialize_goal_scored?(i)
    goal_scored?(@att_hm, @att_aw, i)
  end

  def initialize_build_results(i)
    @res <<
      {
        game_id: @match_id,
        minute: i + 1,
        commentary: @commentary
      }
  end

  def initialize_possession
    calc_possession
  end

  def initialize_motm
    @motm_hm = select_motm(@sqd_pl_hm)
    @motm_aw = select_motm(@sqd_pl_aw)
  end

  def initialize_commentary
    home_team = Club.find_by(abbreviation: @club_hm)&.name
    away_team = Club.find_by(abbreviation: @club_hm)&.name
    scorer = Player.find_by(id: @goal[:scorer])&.name
    assister = Player.find_by(id: @goal[:assist])&.name
    general_commentary = Template.random_match_general_commentary
    chance_commentary = Template.random_match_chance_commentary

    if @goal_scored == 'home goal'
      @commentary = "Great play by #{home_team} as #{assister} creates a great chance for #{scorer}.  He hits the shot well and it goes in, great strike!"
    elsif @goal_scored == 'away goal'
      @commentary = @commentary = "Great play by #{away_team} as #{assister} creates a great chance for #{scorer}.  He hits the shot well and it goes in, great strike!"
    elsif @cha_res == 'home' && @cha_on_tar == 'home'
      @commentary = "#{home_team} have a chance that is on target but they miss"
    elsif @cha_res == 'away' && @cha_on_tar == 'away'
      @commentary = "#{away_team} have a chance that is on target but they miss"
    elsif @cha_res == 'home'
      @commentary = home_team + chance_commentary
    elsif @cha_res == 'away'
      @commentary = away_team + chance_commentary
    else
      @commentary = general_commentary
    end
  end
end