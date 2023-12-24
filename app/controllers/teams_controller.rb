class TeamsController < ApplicationController
  def index
    @clubs = Player.distinct.pluck(:club)
    @selected_club = params[:club] || @clubs.first
    @squad = Player.where(club: @selected_club)
    @squad_pl = squad_pl
    @def, @mid, @att = team_tot(@squad_pl)
  end

  def squad_pl
    @squad = @squad.map do |player|
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

  def team_tot(squad_pl)
    @def = 0
    @mid = 0
    @att = 0
  
    squad_pl.each do |player|
      case player[:pos]
      when 'gkp', 'def'
        @def += player[:match_perf]
      when 'mid'
        @mid += player[:match_perf]
      else
        @att += player[:match_perf]
      end
    end
  
    return @def, @mid, @att
  end

  def pos_skl(player)
    if player.pos == 'gkp'
      player.gkp_skill
    elsif player.pos == 'def'
      player.def_skill
    elsif player.pos == 'mid'
      player.mid_skill
    else
      player.att_skill
    end
  end
end
