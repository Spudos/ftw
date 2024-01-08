module MatchesMinByMinHelper
  def cha?
    cha = @hm_mod - @aw_mod
    if cha >= 0 && rand(0..100) < 16
      @cha_res = 'home'
    elsif cha.negative? && rand(0..100) < 16
      @cha_res = 'away'
    else
      @cha_res = add_rand_cha
    end
  end

  def add_rand_cha
    random_number = rand(1..100)

    if random_number <= 5
      @cha_res = 'home'
    elsif random_number > 5 && random_number <= 10
      @cha_res = 'away'
    else
      @cha_res = 'none'
    end
  end

  def cha_count
    if @cha_res == 'home'
      @cha_count_hm += 1
    elsif @cha_res == 'away'
      @cha_count_aw += +1
    end
  end

  def cha_on_tar(att_hm, att_aw)
    if @cha_res == 'home' && att_hm / 2 > rand(0..100)
      @cha_on_tar = 'home'
      @cha_on_tar_hm += 1
    elsif @cha_res == 'away' && att_aw / 2 > rand(0..100)
      @cha_on_tar = 'away'
      @cha_on_tar_aw += 1
    else
      @cha_on_tar = 'none'
    end
  end

  def goal_scored?(att_hm, att_aw, i)
    if @cha_on_tar == 'home' && att_hm / 3 > rand(0..100)
      @goal_scored = 'home goal'
      @goal_hm += 1
      assist_and_scorer(@sqd_pl_hm, i)
    elsif @cha_on_tar == 'away' && att_aw / 3 > rand(0..100)
      @goal_scored = 'away goal'
      @goal_aw += 1
      assist_and_scorer(@sqd_pl_aw, i)
    else
      @goal_scored = 'no'
      @goal = { scorer: 'none', assist: 'none' }
    end
  end

  def assist_and_scorer(sqd_pl, i)

    match_id = sqd_pl.first[:match_id]

    filtered_players = sqd_pl.reject { |player| player[:pos] == 'gkp' }

    top_players = filtered_players.sort_by { |player| -player[:match_perf] }
                                  .first(5)
                                  .map { |player| player[:id] }

    selected_players = top_players.sample(2)
    scorer = selected_players[0]
    assist = selected_players[1]

    while scorer == assist
      assist = top_players.sample
    end

    @goal = { scorer: scorer, assist: assist , time: i}

    player_stats = {}
    sqd_pl.each do |player|
      player_stats[player[:id]] = { goals: 0, assists: 0, time: i, match_id: match_id }
    end

    player_stats[scorer][:goals] += 1
    player_stats[assist][:assists] += 1

    player_stats.each do |player_id, stats|
      if stats[:goals] > 0 || stats[:assists] > 0
        PlStat.create(player_id: player_id, match_id: stats[:match_id], time: stats[:time], goal: stats[:goals] > 0, assist: stats[:assists] > 0)
      end
    end

    { goal: @goal, player_stats: player_stats }
  end
end