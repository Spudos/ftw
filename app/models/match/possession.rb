class Match::Possession
  attr_reader :match_summary

  def initialize(match_summary)
    @match_summary = match_summary
  end

  def call
    if match_summary.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    if (match_summary[:chance_count_home] + match_summary[:chance_count_away]) == 0
      away_possession = 48
    else
      away_possession = (match_summary[:chance_count_away] / (match_summary[:chance_count_home] + match_summary[:chance_count_away]).to_f * 80).to_i
      if away_possession <= 20
        away_possession = rand(20..30)
      end
    end

    home_possession = 100 - away_possession

    { home_possession:, away_possession:}
  end
end
