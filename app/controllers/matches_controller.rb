class MatchesController < ApplicationController
  helper_method :summarize_results
  def index; end

  def show; end

  def match
    @cha_on_tar_home = 0
    @cha_on_tar_away = 0

    initialize_squad # output @squad including all alv players
    initialize_squad_pl(@sqd) # output @squad_pl which is a hash of players with match perf
    initialize_team_totals(@sqd_pl) # output @dfc, @mid, @att using player match_perf
    add_rand_cha

    @res = []
    90.times do |i|
      initialize_team_cha_val(@mid, @att) # output @home_mod, @away_mod
      cha?(@hm_mod, @aw_mod) # output @cha_res
      cha_on_tar(@att, @cha_res) # ouput cha_on_tar
      initialize_build_results(i, @hm_mod, @aw_mod, @cha, @cha_res, @cha_on_tar) # output @results
    end
  end

  private

  def initialize_squad
    @sqd = Player.where(club: 'alv')
  end

  def initialize_squad_pl(sqd)
    @sqd_pl = squad_pl(sqd)
  end

  def initialize_team_totals(sqd_pl)
    @dfc, @mid, @att = team_totals(sqd_pl)
  end

  def initialize_team_cha_val(mid, att)
    @aw_mod = (150 + (100 * 0.50)) + rand(-20..20)
    @hm_mod = (mid + (att * 0.50)) + rand(-20..20)
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

  def cha?(hm_mod, aw_mod)
    cha = hm_mod - aw_mod
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

    if random_number <= 10
      @cha_res = 'home'
    elsif random_number > 10 && random_number <= 20
      @cha_res = 'away'
    else
      @cha_res = 'none'
    end
  end

  def cha_on_tar(att, cha_res)


    if cha_res == 'home' && att / 2 > rand(0..100)
      @cha_on_tar = true
      @cha_on_tar_home += 1
    elsif cha_res == 'away' && 100 / 2 > rand(0..100)
      @cha_on_tar = true
      @cha_on_tar_away += 1
    else
      @cha_on_tar = false
    end
  end
end
