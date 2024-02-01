class Match::BlendAdd
  attr_reader :blend_totals, :match_info

  def initialize(blend_totals, match_info)
    @blend_totals = blend_totals
    @match_info = match_info
  end

  def call
    updated_match_info = match_info.merge(
      {
        dfc_blend_home: blend_totals[0][:defense],
        mid_blend_home: blend_totals[0][:midfield],
        att_blend_home: blend_totals[0][:attack],
        dfc_blend_away: blend_totals[1][:defense],
        mid_blend_away: blend_totals[1][:midfield],
        att_blend_away: blend_totals[1][:attack]
      }
    )
    updated_match_info
  end
end
