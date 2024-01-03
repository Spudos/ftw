module MatchesEndOfGameHelper
  def calc_possession
    @hm_poss = (@cha_count_hm / (@cha_count_hm + @cha_count_aw.to_f) * 80).to_i
    @aw_poss = 100 - @hm_poss.to_i
  end

  def select_motm(sqd_pl)
    sqd_pl.max_by { |player| player[:match_perf] }[:id]
  end

  def initalize_save
    match = Matches.new(
      match_id: @match_id,
      week_number: @week_number,
      hm_team: @club_hm,
      aw_team: @club_aw,
      hm_poss: @hm_poss,
      aw_poss: @aw_poss,
      hm_cha: @cha_count_hm,
      aw_cha: @cha_count_aw,
      hm_cha_on_tar: @cha_on_tar_hm,
      aw_cha_on_tar: @cha_on_tar_aw,
      hm_goal: @goal_hm,
      aw_goal: @goal_aw,
      hm_motm: @motm_hm,
      aw_motm: @motm_aw,
    )

    if match.save
      puts "Match data saved successfully."
    else
      puts "Failed to save match data."
    end
  end
end