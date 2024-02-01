class Match::AggressionEffect
  attr_reader :totals_with_stadium

  def initialize(totals_with_stadium)
    @totals_with_stadium = totals_with_stadium
  end

  def call
    totals_with_aggression = []

    totals_with_stadium.each do |team|
      hash = {
        team: team[:team],
        defense: team[:defense] + Tactic.find_by(abbreviation: team[:team])&.dfc_aggression * 5,
        midfield: team[:midfield] + Tactic.find_by(abbreviation: team[:team])&.mid_aggression * 5,
        attack: team[:attack] + Tactic.find_by(abbreviation: team[:team])&.att_aggression * 5
      }
      totals_with_aggression << hash
    end
    return totals_with_aggression
  end
end
