class Match::Blends
  attr_reader :totals

  def initialize(totals)
    @totals = totals
  end

  def run
    totals_with_blend = []
    blend_totals = []

    totals.each do |team|

      hash = {
        team: team[:team],
        defense: (team[:defense] * (1 - ((team[:defense_blend].to_f) / 10) / 2)).to_i,
        midfield: (team[:midfield] * (1 - ((team[:midfield_blend].to_f) / 10) / 2)).to_i,
        attack: (team[:attack] * (1 - ((team[:attack_blend].to_f) / 10) / 2)).to_i
      }
      totals_with_blend << hash
    end

    totals.each do |team|
      hash = {
        team: team[:team],
        defense: team[:defense_blend],
        midfield: team[:midfield_blend],
        attack: team[:attack_blend]
    }
    blend_totals << hash
    end

    return totals_with_blend, blend_totals
  end
end
