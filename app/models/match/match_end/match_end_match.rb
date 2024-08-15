class Match::MatchEnd::MatchEndMatch
  attr_reader :fixture_attendance, :selection_complete, :tactic, :match_summaries

  def initialize(fixture_attendance, selection_complete, tactic, match_summaries)
    @match_summaries = match_summaries
    @fixture_attendance = fixture_attendance
    @selection_complete = selection_complete
    @tactic = tactic
  end

  def call
    if match_summaries.nil? || fixture_attendance.nil? || selection_complete.nil? || tactic.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    match_upload = []

    fixture_attendance.each do |match|
      summary = match_summaries.find { |hash| hash[:home_club] == match[:club_home] }
      match_upload << save_match(match, summary)
    end

    match_attributes = match_upload.to_a.map(&:as_json)
    Match.upsert_all(match_attributes)
  end

  private

  def save_match(match, summary)
    {
      match_id: match[:id].to_i,
      week_number: match[:week_number].to_i,
      competition: match[:competition],
      home_team: match[:club_home],
      tactic_home: tactic[0][:tactic],
      dfc_blend_home: summary[:dfc_blend_home],
      mid_blend_home: summary[:mid_blend_home],
      att_blend_home: summary[:att_blend_home],
      dfc_aggression_home: tactic[0][:dfc_aggression],
      mid_aggression_home: tactic[0][:mid_aggression],
      att_aggression_home: tactic[0][:att_aggression],
      home_press: tactic[0][:press],
      away_team: match[:club_away],
      tactic_away: tactic[1][:tactic],
      dfc_blend_away: summary[:dfc_blend_away],
      mid_blend_away: summary[:mid_blend_away],
      att_blend_away: summary[:att_blend_away],
      dfc_aggression_away: tactic[1][:dfc_aggression],
      mid_aggression_away: tactic[1][:mid_aggression],
      att_aggression_away: tactic[1][:att_aggression],
      away_press: tactic[1][:press],
      home_possession: summary[:home_possession],
      away_possession: summary[:away_possession],
      home_chance: summary[:home_chance],
      away_chance: summary[:away_chance],
      home_chance_on_target: summary[:home_target],
      away_chance_on_target: summary[:away_target],
      home_goals: summary[:home_goals],
      away_goals: summary[:away_goals],
      home_man_of_the_match: man_of_the_match(match[:club_home]),
      away_man_of_the_match: man_of_the_match(match[:club_away]),
      attendance: match[:attendance]
    }
  end

  def man_of_the_match(team)
    player_hash = []

    selection_complete.each do |player|
      player_hash << player if player[:club_id] == team
    end

    player_hash.max_by { |player| player[:performance] }[:player_id]
  end
end
