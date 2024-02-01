class Match::StarEffect
  attr_reader :squads_tactics

  def initialize(squads_tactics)
    @squads_tactics = squads_tactics
  end

  def call
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
