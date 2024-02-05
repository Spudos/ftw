class Match::SaveDetailedMatchSummary
  attr_reader :detailed_match_summary

  def initialize(detailed_match_summary)
    @detailed_match_summary = detailed_match_summary
  end

  def call
    if detailed_match_summary.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    match_data = detailed_match_summary[0]
    match = Match.new(
      match_id: match_data[:id].to_i,
      week_number: match_data[:week].to_i,
      competition: match_data[:competition],
      home_team: match_data[:club_home],
      tactic_home: match_data[:tactic_home],
      dfc_blend_home: match_data[:dfc_blend_home],
      mid_blend_home: match_data[:mid_blend_home],
      att_blend_home: match_data[:att_blend_home],
      dfc_aggression_home: match_data[:dfc_aggression_home],
      mid_aggression_home: match_data[:mid_aggression_home],
      att_aggression_home: match_data[:att_aggression_home],
      home_press: match_data[:home_press],
      away_team: match_data[:club_away],
      tactic_away: match_data[:tactic_away],
      dfc_blend_away: match_data[:dfc_blend_away],
      mid_blend_away: match_data[:mid_blend_away],
      att_blend_away: match_data[:att_blend_away],
      dfc_aggression_away: match_data[:dfc_aggression_away],
      mid_aggression_away: match_data[:mid_aggression_away],
      att_aggression_away: match_data[:att_aggression_away],
      away_press: match_data[:away_press],
      home_possession: match_data[:home_possession].to_i,
      away_possession: match_data[:away_possession].to_i,
      home_chance: match_data[:chance_count_home].to_i,
      away_chance: match_data[:chance_count_away].to_i,
      home_chance_on_target: match_data[:chance_on_target_home].to_i,
      away_chance_on_target: match_data[:chance_on_target_away].to_i,
      home_goals: match_data[:goal_home].to_i,
      away_goals: match_data[:goal_away].to_i,
      home_man_of_the_match: match_data[:home_man_of_the_match],
      away_man_of_the_match: match_data[:away_man_of_the_match],
    )

    if match.save
      puts "Match data saved successfully."
    else
      puts "Failed to save match data."
    end
  end
end
