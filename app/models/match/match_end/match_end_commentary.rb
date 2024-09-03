class Match::MatchEnd::MatchEndCommentary
  attr_reader :fixture_attendance, :summary, :selection_complete

  def initialize(fixture_attendance, summary, selection_complete)
    @summary = summary
    @selection_complete = selection_complete
    @fixture_attendance = fixture_attendance
  end

  def call
    if @summary.nil? || @selection_complete.nil? || @fixture_attendance.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    commentary_upload = []

    fixture_iteration(commentary_upload)

    commentary_attributes = commentary_upload.to_a.map(&:as_json)
    Commentary.upsert_all(commentary_attributes)
  end

  def fixture_iteration(commentary_upload)
    sorted = summary.group_by { |element| element[1][0][:club_id] }

    fixture_attendance.each do |match|
      match_detail = sorted.find { |hash| hash[0] == match[:club_home] }

      home_players = selection_complete.select { |player| player[:club_id] == match[:club_home] }
      away_players = selection_complete.select { |player| player[:club_id] == match[:club_away] }

      generate_commentary_data(match, match_detail, home_players, away_players, commentary_upload)
    end
  end

  def generate_commentary_data(match, match_detail, home_players, away_players, commentary_upload)
    home_score = 0
    away_score = 0

    match_detail[1].each do |record|
      home_filtered_list = home_players.reject { |player| player[:position] == 'gkp' }
      away_filtered_list = away_players.reject { |player| player[:position] == 'gkp' }

      commentary_data = { match_id: match[:id],
                          minute: record[0],
                          home_team: match[:club_home],
                          away_team: match[:club_away],
                          chance_outcome: record[4][:chance_outcome],
                          chance_target: record[5][:chance_on_target],
                          goal_scored: record[6][:goal_scored],
                          scorer: record[7][:scorer],
                          assister: record[7][:assist],
                          home_name: home_filtered_list.sample[:name],
                          away_name: away_filtered_list.sample[:name] }

      generate_commentary(commentary_data, commentary_upload, home_score, away_score)
    end
  end

  private

  def generate_commentary(commentary_data, commentary_upload, home_score, away_score)
    general_commentary, chance_commentary, chance_tar_commentary, goal_commentary, club_names = commentary_templates

    home_name = club_names.find { |element| element[0] == commentary_data[:home_team].to_i }[1]
    away_name = club_names.find { |element| element[0] == commentary_data[:away_team].to_i }[1]

    if commentary_data[:goal_scored] == 'home'
      scorer = selection_complete.find { |element| element[:player_id] == commentary_data[:scorer] }[:name]
      assister = selection_complete.find { |element| element[:player_id] == commentary_data[:assister] }[:name]
      home_score += 1
      event = 'Home Goal'
      commentary = goal_commentary.gsub('{team}', home_name)
                                  .gsub('{assister}', assister)
                                  .gsub('{scorer}', scorer)
    elsif commentary_data[:goal_scored] == 'away'
      scorer = selection_complete.find { |element| element[:player_id] == commentary_data[:scorer] }[:name]
      assister = selection_complete.find { |element| element[:player_id] == commentary_data[:assister] }[:name]
      away_score += 1
      event = 'Away Goal'
      commentary = goal_commentary.gsub('{team}', away_name)
                                  .gsub('{assister}', assister)
                                  .gsub('{scorer}', scorer)
    elsif commentary_data[:chance_target] == 'home'
      event = 'Good chance'
      commentary = chance_tar_commentary.gsub('{team}', home_name)
                                        .gsub('{player}', commentary_data[:home_name])
    elsif commentary_data[:chance_target] == 'away'
      event = 'Good chance'
      commentary = chance_tar_commentary.gsub('{team}', away_name)
                                        .gsub('{player}', commentary_data[:away_name])
    elsif commentary_data[:chance_outcome] == 'home'
      event = 'Chance'
      commentary = chance_commentary.gsub('{team}', home_name)
                                    .gsub('{player}', commentary_data[:home_name])
    elsif commentary_data[:chance_outcome] == 'away'
      event = 'Chance'
      commentary = chance_commentary.gsub('{team}', away_name)
                                    .gsub('{player}', commentary_data[:away_name])
    else
      event = ''
      team_names = [away_name, home_name]
      selected_team = team_names.sample
      commentary = general_commentary.gsub('{team}', selected_team)
    end

    commentary = { match_id: commentary_data[:match_id],
                   minute: commentary_data[:minute],
                   commentary:,
                   event:,
                   home_score:,
                   away_score: }

    commentary_upload << commentary
  end

  def commentary_templates
    general_commentary = Template.random_match_general_commentary
    chance_commentary = Template.random_match_chance_commentary
    chance_tar_commentary = Template.random_match_chance_tar_commentary
    goal_commentary = Template.random_match_goal_commentary
    club_names ||= Club.all.pluck(:id, :name)

    return general_commentary, chance_commentary, chance_tar_commentary, goal_commentary, club_names
  end
end
