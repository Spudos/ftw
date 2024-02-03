class Match::AggressionEffect
  attr_reader :totals_stadium

  def initialize(totals_stadium)
    @totals_stadium = totals_stadium
  end

  def call
    if totals_stadium.empty?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    totals_aggression = []

    totals_stadium.each do |team|
      hash = {
        team: team[:team],
        defense: team[:defense] + Tactic.find_by(abbreviation: team[:team])&.dfc_aggression * 5,
        midfield: team[:midfield] + Tactic.find_by(abbreviation: team[:team])&.mid_aggression * 5,
        attack: team[:attack] + Tactic.find_by(abbreviation: team[:team])&.att_aggression * 5
      }
      totals_aggression << hash
    end
    return totals_aggression
  end
end
