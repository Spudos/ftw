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
        number: i + 1,
        hm_mod: @hm_mod,
        aw_mod: @aw_mod,
        cha: @cha,
        cha_res: @cha_res,
        cha_count_hm: @cha_count_hm,
        cha_count_aw: @cha_count_aw,
        cha_on_tar: @cha_on_tar,
        goal_scored?: @goal_scored,
        assist: @goal.empty? ? nil : @goal[:assist],
        scorer: @goal.empty? ? nil : @goal[:scorer]
      }
  end

  def initialize_possession
    calc_possession
  end

  def initialize_motm
    @motm_hm = select_motm(@sqd_pl_hm)
    @motm_aw = select_motm(@sqd_pl_aw)
  end
end