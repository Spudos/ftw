class MatchesController < ApplicationController
  def index; end

  def show
    @match = Matches.find_by(match_id: params[:id])
    @pl_match = PlMatch.where(match_id: params[:id])
    @pl_stats = PlStat.where(match_id: params[:id])

    @players = []
    @pl_match.each do |pl_match|
      player = Player.find_by(id: pl_match.player_id)
      @players << player if player
    end
  end

  def match
    initialize_sqd_setup
    initialize_min_by_min
    initialize_end_of_game
  end

  private

  # match sections
  #----------------------------------------------------------------
  def initialize_sqd_setup
    @cha_count_hm = 0
    @cha_count_aw = 0
    @cha_on_tar_hm = 0
    @cha_on_tar_aw = 0
    @goal_hm = 0
    @goal_aw = 0
    @hm_poss = 0
    @aw_poss = 0

    initialize_sqd
    initialize_sqd_pl
    initialize_tm_tot
  end

  def initialize_min_by_min
    @res = []
    rand(90..98).times do |i|
      initialize_tm_cha_val
      initialize_cha?
      initialize_cha_count
      initialize_cha_on_tar
      initialize_goal_scored?
      initialize_build_results(i)
    end
  end

  def initialize_end_of_game
    initialize_possession
    initialize_motm
    initalize_save
  end

  # initializers
  #----------------------------------------------------------------
  def initialize_sqd
    @match_id = params[:match_id]
    @club_hm = params[:club_hm]
    @club_aw = params[:club_aw]

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

  def initialize_goal_scored?
    goal_scored?(@att_hm, @att_aw)
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
        assist: @goal[:assist],
        scorer: @goal[:scorer]
      }
  end

  def initialize_possession
    calc_possession
  end

  def initialize_motm
    @motm_hm = select_motm(@sqd_pl_hm)
    @motm_aw = select_motm(@sqd_pl_aw)
  end

  # squad setup
  #----------------------------------------------------------------
  def sqd_pl(sqd)
    sqd.map do |player|
      pl_match = PlMatch.create(
        player_id: player.id,
        match_id: @match_id,
        match_perf: player.match_perf(player)
      )

      {
        match_id: @match_id,
        id: player.id,
        club: player.club,
        name: player.name,
        pos: player.pos,
        total_skill: player.total_skill,
        match_perf: player.match_perf(player),
        match_id: @match_id
      }
    end
  end

  def tm_tot(sqd_pl)
    dfc = 0
    mid = 0
    att = 0

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

  # min by min
  #----------------------------------------------------------------
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

  def goal_scored?(att_hm, att_aw)
    if @cha_on_tar == 'home' && att_hm / 3 > rand(0..100)
      @goal_scored = 'home goal'
      @goal_hm += 1
      assist_and_scorer(@sqd_pl_hm)
    elsif @cha_on_tar == 'away' && att_aw / 3 > rand(0..100)
      @goal_scored = 'away goal'
      @goal_aw += 1
      assist_and_scorer(@sqd_pl_aw)
    else
      @goal_scored = 'no'
      @goal = { scorer: 'none', assist: 'none' }
    end
  end

  def assist_and_scorer(sqd_pl)
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

    goal = { scorer: scorer, assist: assist }

    player_stats = {}
    sqd_pl.each do |player|
      player_stats[player[:id]] = { goals: 0, assists: 0, match_id: match_id }
    end

    player_stats[scorer][:goals] += 1
    player_stats[assist][:assists] += 1

    player_stats.each do |player_id, stats|
      if stats[:goals] > 0 || stats[:assists] > 0
        PlStat.create(player_id: player_id, match_id: stats[:match_id], goal: stats[:goals] > 0, assist: stats[:assists] > 0)
      end
    end

    { goal: goal, player_stats: player_stats }
  end

  # end of game
  #----------------------------------------------------------------
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
      aw_motm: @motm_aw
    )

    if match.save
      puts "Match data saved successfully."
    else
      puts "Failed to save match data."
    end
  end
end
