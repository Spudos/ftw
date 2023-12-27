class MatchesController < ApplicationController
  helper_method :summarize_results
  def index; end

  def show; end

  def match
    initialize_sqd_setup
    initialize_min_by_min
  end

  private

  # match sections
  #----------------------------------------------------------------
  def initialize_sqd_setup
    @cha_on_tar_home = 0
    @cha_on_tar_away = 0
    @goal_home = 0
    @goal_away = 0

    initialize_sqd # output @squad including all alv players
    initialize_sqd_pl # output @squad_pl which is a hash of players with match perf
    initialize_tm_tot # output @dfc, @mid, @att using player match_perf
  end

  def initialize_min_by_min
    @res = []
    rand(90..98).times do |i|
      initialize_tm_cha_val # output @home_mod, @away_mod
      initialize_cha? # output @cha_res
      initialize_cha_on_tar # ouput cha_on_tar
      initialize_assist_and_scorer
      initialize_goal_scored?
      initialize_build_results(i) # output @results
    end
  end

  # initializers
  #----------------------------------------------------------------
  def initialize_sqd
    @sqd = Player.where(club: 'alv')
  end

  def initialize_sqd_pl
    @sqd_pl = sqd_pl
  end

  def initialize_tm_tot
    @dfc, @mid, @att = tm_tot
  end

  def initialize_tm_cha_val
    @aw_mod = (150 + (100 * 0.50)) + rand(-20..20)
    @hm_mod = (@mid + (@att * 0.50)) + rand(-20..20)
  end

  def initialize_cha?
    @cha_res = cha?
  end

  def initialize_cha_on_tar
    cha_on_tar
  end

  def initialize_assist_and_scorer
    assist_and_scorer
  end

  def initialize_goal_scored?
    goal_scored?
  end

  def initialize_build_results(i)
    @res <<
      {
        number: i + 1,
        hm_mod: @hm_mod,
        aw_mod: @aw_mod,
        cha: @cha,
        cha_res: @cha_res,
        cha_on_tar: @cha_on_tar,
        goal_scored?: @goal_scored,
        assist: @goal[:assist], # Insert the assist value from the @goal hash
        scorer: @goal[:scorer]  # Insert the scorer value from the @goal hash
      }
  end

  # helper methods
  #----------------------------------------------------------------
  def summarize_results
    test_counts = Hash.new(0)

    @res.each do |res|
      test_counts[res[:cha_res]] += 1
    end

    test_counts
  end

  # squad setup
  #----------------------------------------------------------------
  def sqd_pl
    @sqd.map do |player|
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

  def tm_tot
    dfc = 0
    mid = 0
    att = 0

    @sqd_pl.each do |player|
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

  def cha_on_tar
    if @cha_res == 'home' && @att / 2 > rand(0..100)
      @cha_on_tar = 'home'
      @cha_on_tar_home += 1
    elsif @cha_res == 'away' && 100 / 2 > rand(0..100)
      @cha_on_tar = 'away'
      @cha_on_tar_away += 1
    else
      @cha_on_tar = 'none'
    end
  end

  def goal_scored?
    if @cha_on_tar == 'home' && @att / 3 > rand(0..100)
      @goal_scored = 'home goal'
      @goal_home += 1
    elsif @cha_on_tar == 'away' && 100 / 3 > rand(0..100)
      @goal_scored = 'away goal'
      @goal_away += 1
    else
      @goal_scored = 'no'
    end
  end

  def assist_and_scorer
    top_players = @sqd_pl.sort_by { |player| -player[:match_perf] }
                        .first(5)
                        .map { |player| player[:name] }
    selected_players = top_players.sample(2)
    scorer = selected_players[0]
    assist = selected_players[1]
    while scorer == assist
      assist = top_players.sample
    end
    @goal = { scorer: scorer, assist: assist }
  end
end
