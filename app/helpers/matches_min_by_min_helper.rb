module MatchesMinByMinHelper


  def chance_count
    if @chance_res == 'home'
      @chance_count_home += 1
    elsif @chance_res == 'away'
      @chance_count_away += +1
    end
  end

  def chance_on_target(att_home, att_away)
    if @chance_res == 'home' && att_home / 2 > rand(0..100)
      @chance_on_target = 'home'
      @chance_on_target_home += 1
    elsif @chance_res == 'away' && att_away / 2 > rand(0..100)
      @chance_on_target = 'away'
      @chance_on_target_away += 1
    else
      @chance_on_target = 'none'
    end
  end

  def goal_scored?(att_home, att_away, i)
    if @chance_on_target == 'home' && att_home / 3 > rand(0..100)
      @goal_scored = 'home goal'
      @goal_home += 1
      assist_and_scorer(@sqd_pl_home, i)
    elsif @chance_on_target == 'away' && att_away / 3 > rand(0..100)
      @goal_scored = 'away goal'
      @goal_away += 1
      assist_and_scorer(@sqd_pl_away, i)
    else
      @goal_scored = 'no'
      @goal = { scorer: 'none', assist: 'none' }
    end
  end

  def assist_and_scorer(sqd_pl, i)

    match_id = sqd_pl.first[:match_id]

    filtered_players = sqd_pl.reject { |player| player[:pos] == 'gkp' }

    top_players = filtered_players.sort_by { |player| -player[:match_performance] }
                                  .first(5)
                                  .map { |player| player[:id] }

    selected_players = top_players.sample(2)
    scorer = selected_players[0]
    assist = selected_players[1]

    while scorer == assist
      assist = top_players.sample
    end

    @goal = { scorer: scorer, assist: assist , time: i}

    player_statistics = {}
    sqd_pl.each do |player|
      player_statistics[player[:id]] = { goals: 0, assists: 0, time: i, match_id: match_id }
    end

    player_statistics[scorer][:goals] += 1
    player_statistics[assist][:assists] += 1

    player_statistics.each do |player_id, statistics|
      if statistics[:goals] > 0 || statistics[:assists] > 0
        PlStat.create(player_id: player_id, match_id: statistics[:match_id], time: statistics[:time], goal: statistics[:goals] > 0, assist: statistics[:assists] > 0)
      end
    end

    { goal: @goal, player_statistics: player_statistics }
  end
end