class Match::TeamTotals
  attr_reader :final_squad_totals

  def initialize(final_squad_totals)
    @final_squad_totals = final_squad_totals
  end

  def team_totals
    squads = final_squad_totals

    home_team = squads.first[:club]
    away_team = squads.last[:club]

    home_dfc = 0
    home_dfc_blend = []
    home_mid = 0
    home_mid_blend = []
    home_att = 0
    home_att_blend = []
    away_dfc = 0
    away_dfc_blend = []
    away_mid = 0
    away_mid_blend = []
    away_att = 0
    away_att_blend = []


    squads.each do |player|
      case player[:player_position]
      when 'gkp', 'dfc'
        if player[:club] == home_team
          home_dfc += player[:match_performance]
          home_dfc_blend.append(player[:player_blend])
        else
          away_dfc += player[:match_performance]
          away_dfc_blend.append(player[:player_blend])
        end
      when 'mid'
        if player[:club] == home_team
          home_mid += player[:match_performance]
          home_mid_blend.append(player[:player_blend])
        else
          away_mid += player[:match_performance]
          away_mid_blend.append(player[:player_blend])
        end
      else
        if player[:club] == home_team
          home_att += player[:match_performance]
          home_att_blend.append(player[:player_blend])
        else
          away_att += player[:match_performance]
          away_att_blend.append(player[:player_blend])
        end
      end
    end

    totals = [
      {
        team: home_team,
        defense: home_dfc,
        defense_blend: home_dfc_blend.max - home_dfc_blend.min,
        midfield: home_mid,
        midfield_blend: home_mid_blend.max - home_mid_blend.min,
        attack: home_att,
        attack_blend: home_att_blend.max - home_att_blend.min
      },
      {
        team: away_team,
        defense: away_dfc,
        defense_blend: away_dfc_blend.max - away_dfc_blend.min,
        midfield: away_mid,
        midfield_blend: away_mid_blend.max - away_mid_blend.min,
        attack: away_att,
        attack_blend: away_att_blend.max - away_att_blend.min
      }
    ]
    totals
  end
end
