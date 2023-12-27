class MatchesController < ApplicationController
  helper_method :summarize_results
  def index; end

  def show; end

  def match
    @cha_on_tar_home = 0
    @cha_on_tar_away = 0

    initialize_squad # output @squad including all alv players
    initialize_squad_pl # output @squad_pl which is a hash of players with match perf
    initialize_team_totals # output @dfc, @mid, @att using player match_perf

    @res = []
    rand(90..98).times do |i|
      initialize_team_cha_val # output @home_mod, @away_mod
      initialize_cha? # output @cha_res
      initialize_cha_on_tar # ouput cha_on_tar
      initialize_build_results(i, @hm_mod, @aw_mod, @cha, @cha_res, @cha_on_tar) # output @results
    end
  end

  private

  def initialize_squad
    @sqd = Player.where(club: 'alv')
  end

  def initialize_squad_pl
    @sqd_pl = squad_pl(@sqd)
  end

  def initialize_team_totals
    @dfc, @mid, @att = team_totals(@sqd_pl)
  end

  def initialize_team_cha_val
    @aw_mod = (150 + (100 * 0.50)) + rand(-20..20)
    @hm_mod = (@mid + (@att * 0.50)) + rand(-20..20)
  end

  def initialize_cha?
    @cha_res = cha?
  end

  def initialize_cha_on_tar
    cha_on_tar
  end

  def initialize_build_results(i, hm_mod, aw_mod, cha, cha_res, cha_on_tar)
    if cha_res != 'none'
      @res << { number: i + 1, hm_mod:, aw_mod:, cha:, cha_res:, cha_on_tar:}
    end
  end

  def summarize_results
    test_counts = Hash.new(0)

    @res.each do |res|
      test_counts[res[:cha_res]] += 1
    end

    test_counts
  end

  def squad_pl(sqd)
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

  def team_totals(sqd_pl)
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
      @cha_on_tar = true
      @cha_on_tar_home += 1
      goal_scored('home')
    elsif @cha_res == 'away' && 100 / 2 > rand(0..100)
      @cha_on_tar = true
      @cha_on_tar_away += 1
      goal_scored('away')
    else
      @cha_on_tar = false
    end
  end

  def select_top_players(sqd_pl)
    top_players = sqd_pl.sort_by { |player| -player[:match_perf] }
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

  def goal_scored(who)
    select_top_players(@sqd_pl)
  end
end
