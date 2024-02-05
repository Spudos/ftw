class Match::MatchSummary
  attr_reader :minute_by_minute

  def initialize(minute_by_minute)
    @minute_by_minute = minute_by_minute
  end

  def call
    if @minute_by_minute.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end
    
    match_summary = {
      id: minute_by_minute.first[:id],
      week: minute_by_minute.first[:week],
      competition: minute_by_minute.first[:competition],
      club_home: minute_by_minute.first[:club_home],
      tactic_home: minute_by_minute.first[:tactic_home],
      dfc_blend_home: minute_by_minute.first[:dfc_blend_home],
      mid_blend_home: minute_by_minute.first[:mid_blend_home],
      att_blend_home: minute_by_minute.first[:att_blend_home],
      dfc_aggression_home: minute_by_minute.first[:dfc_aggression_home],
      mid_aggression_home: minute_by_minute.first[:mid_aggression_home],
      att_aggression_home: minute_by_minute.first[:att_aggression_home],
      home_press: minute_by_minute.first[:home_press],
      club_away: minute_by_minute.first[:club_away],
      tactic_away: minute_by_minute.first[:tactic_away],
      dfc_blend_away: minute_by_minute.first[:dfc_blend_away],
      mid_blend_away: minute_by_minute.first[:mid_blend_away],
      att_blend_away: minute_by_minute.first[:att_blend_away],
      dfc_aggression_away: minute_by_minute.first[:dfc_aggression_away],
      mid_aggression_away: minute_by_minute.first[:mid_aggression_away],
      att_aggression_away: minute_by_minute.first[:att_aggression_away],
      away_press: minute_by_minute.first[:away_press],
      chance_count_home: minute_by_minute.count { |chance| chance[:chance_outcome] == 'home' },
      chance_count_away: minute_by_minute.count { |chance| chance[:chance_outcome] == 'away' },
      chance_on_target_home: minute_by_minute.count { |chance| chance[:chance_on_target] == 'home' },
      chance_on_target_away: minute_by_minute.count { |chance| chance[:chance_on_target] == 'away' },
      goal_home: minute_by_minute.count { |chance| chance[:goal_scored] == 'home' },
      goal_away: minute_by_minute.count { |chance| chance[:goal_scored] == 'away' }
    }
    match_summary
  end
end
