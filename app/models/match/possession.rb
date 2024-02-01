class Match::Possession
  attr_reader :match_summary

  def initialize(match_summary)
    @match_summary = match_summary
  end

  def call
    home_possession = (match_summary[:chance_count_home] / (match_summary[:chance_count_home] + match_summary[:chance_count_away]).to_f * 80).to_i
    away_possession = 100 - home_possession

    { home_possession:, away_possession:}
  end
end