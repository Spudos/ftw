class MatchesController < ApplicationController

  def index
    @sqd_pl_hm = []
    @sqd_pl_aw = []
    @dfc_hm = 0
    @mid_hm = 0
    @att_hm = 0
    @dfc_aw = 0
    @mid_aw = 0
    @att_aw = 0
    @res = []
  end

  def show; end

  def match
    initialize_sqd_setup
    initialize_min_by_min
    save
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
      initialize_build_results(i) # output @results
    end
  end

  def initialize_end_of_game
    initialize_possession
    initialize_motm
    
  end

  # initializers
  #----------------------------------------------------------------
  def initialize_sqd
    club_hm = params[:club_hm]
    club_aw = params[:club_aw]

    @sqd_hm = Player.where(club: club_hm)
    @sqd_aw = Player.where(club: club_aw)
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
        assist: @goal[:assist], # Insert the assist value from the @goal hash
        scorer: @goal[:scorer]  # Insert the scorer value from the @goal hash
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
      pos_skl = pos_skl(player)

      {
        club: player.club,
        name: player.name,
        pos: player.pos,
        base_skl: player.base_skill,
        pos_skl:,
        total_skill: player.total_skill,
        match_perf: player.match_perf(player)
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
    filtered_players = sqd_pl.reject { |player| player[:pos] == 'gkp' }

    top_players = filtered_players.sort_by { |player| -player[:match_perf] }
                                  .first(5)
                                  .map { |player| player[:name] }

    selected_players = top_players.sample(2)
    scorer = selected_players[0]
    assist = selected_players[1]

    while scorer == assist
      assist = top_players.sample
    end

    @goal = { scorer:, assist: }
  end

  # end of game
  #----------------------------------------------------------------
  def calc_possession
    @hm_poss = (@cha_count_hm / (@cha_count_hm + @cha_count_aw.to_f) * 80).to_i
    @aw_poss = 100 - @hm_poss.to_i
  end

  def select_motm(sqd_pl)
    motm = sqd_pl.max_by { |player| player[:match_perf] }[:name]
  end

  def save
    match = Matches.new(
      match_id: 1,
      hm_team: 'liv',
      aw_team: 'alv',
      hm_poss: @hm_poss,
      aw_poss: @aw_poss,
      hm_cha: @hm_cha,
      aw_cha: @aw_cha,
      hm_cha_on_tar: @hm_cha_on_tar,
      aw_cha_on_tar: @aw_cha_on_tar,
      hm_motm: @hm_motm,
      aw_motm: @aw_motm
    )
    
    if match.save
      # Successfully saved the match data
      redirect_to matches_path, notice: "Match data saved successfully."
    else
      # Failed to save the match data
      redirect_to matches_path, alert: "Failed to save match data."
    end
  end
end
