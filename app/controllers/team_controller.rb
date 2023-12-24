class TeamController < ApplicationController
  before_action :load_team
  before_action :calc_team
  
  def load_team
    club = params[:club] # Get the selected club value from the dropdown
    @team = Player.where(club: club) # Filter the players based on the selected club
  end

  def calc_team
    @def_total = 0
    @mid_total = 0
    @att_total = 0
  
    @team.each do |player|
      if player.pos == 'gkp'
        @def_total += player.gkp_skill
      elsif player.pos == 'def'
        @def_total += player.def_skill
      elsif player.pos == 'mid'
        @mid_total += player.mid_skill
      else
        @att_total += player.att_skill
      end
    end
  end
end
