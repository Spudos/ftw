class Match::StarEffect
  attr_reader :squads_tactics

  def initialize(squads_tactics)
    @squads_tactics = squads_tactics
  end

  def call
    if @squads_tactics.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end
    
    players = squads_tactics

    players.each do |player|
      if rand(100) > 50
        player[:match_performance] += player[:star]
      end

      if player[:match_performance] < 20
        player[:match_performance] = rand(20..30)
      end
    end

    totals_with_star = players
  end
end
