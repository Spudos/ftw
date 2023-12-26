class MatchesController < ApplicationController
  helper_method :summarize_results
  def index; end

  def show; end

  def match
    initialize_squad
    initialize_squad_pl
    initialize_team_totals

    @results = []
    90.times do |i|
      initialize_cha_rand(@mid)
      initialize_cha
      initialize_cha_test
      initialize_build_results(i, @mid_mod, @cha, @test)
    end
  end
  

  private

  def initialize_squad
    @squad = Player.where(club: 'alv')
  end

  def initialize_squad_pl
    @squad_pl = squad_pl
  end

  def initialize_team_totals
    @dfc, @mid, @att = team_totals(@squad_pl)
  end

  def initialize_cha_rand(mid)
    @mid_mod = mid + rand(-20..20)
  end

  def initialize_cha
    @cha = cha_to_who(@mid_mod)
  end

  def initialize_cha_test
    cha?(@cha)
  end

  def initialize_build_results(i, mid_mod, cha, test)
    if test != 'none'
      @results << { number: i + 1, mid: @mid, mid_mod: mid_mod, cha: cha, test: test }
    end
  end

  def summarize_results
    test_counts = Hash.new(0)
  
    @results.each do |result|
      test_counts[result[:test]] += 1
    end
  
    test_counts
  end

  def squad_pl
    @squad.map do |player|
      pos_skl = pos_skl(player)

      {
        club: player.club,
        name: player.name,
        pos: player.pos,
        base_skl: player.base_skill,
        pos_skl: pos_skl,
        total_skill: player.total_skill,
        match_perf: player.match_perf(player)
      }
    end
  end

  def team_totals(squad_pl)
    dfc = 0
    mid = 0
    att = 0

    squad_pl.each do |player|
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

  def cha_to_who(mid)
    aw_dfc = 200
    aw_mid = 150
    aw_att = 100

    mid / (aw_mid + mid.to_f)
  end

  def cha?(cha)
    case cha
    when 0.48..0.52
      @test = 'none'
    when 0.52..0.55
      @test = 'low_home'
    when 0.55..0.60
      @test = 'med_home'
    when 0.60..Float::INFINITY
      @test = 'high_home'
    when 0.45..0.48
      @test = 'low_away'
    when 0.4..0.45
      @test = 'med_away'
    else
      @test = 'high_away'
    end
  end
end
