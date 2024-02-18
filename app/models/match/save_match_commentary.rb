class Match::SaveMatchCommentary
  attr_reader :home_list, :away_list, :minute_by_minute

  def initialize(home_list, away_list, minute_by_minute)
    @home_list = home_list
    @away_list = away_list
    @minute_by_minute = minute_by_minute
  end

  def call
    if @home_list.nil? || @away_list.nil? || @minute_by_minute.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    home_team = Club.find_by(club_id: minute_by_minute.first[:club_home])&.name
    away_team = Club.find_by(club_id: minute_by_minute.first[:club_away])&.name

    home_score = 0
    away_score = 0

    minute_by_minute.each do |minute|
      general_commentary = Template.random_match_general_commentary
      chance_commentary = Template.random_match_chance_commentary
      chance_tar_commentary = Template.random_match_chance_tar_commentary
      goal_commentary = Template.random_match_goal_commentary  

      home_filtered_list = home_list.select { |player| player[:player_position] != "gkp" }
      home_name = Player.find_by(id: home_filtered_list.sample[:player_id])&.name

      away_filtered_list = away_list.select { |player| player[:player_position] != "gkp" }
      away_name = Player.find_by(id: away_filtered_list.sample[:player_id])&.name

      time = minute[:minute]
      match_id = minute[:id]

      if minute[:goal_scored] == 'home'
        scorer = Player.find_by(id: minute[:scorer])&.name
        assister = Player.find_by(id: minute[:assist])&.name
        home_score += 1
        event = 'Home Goal'
        commentary = goal_commentary.gsub('{team}', home_team).gsub('{assister}', assister).gsub('{scorer}', scorer)
      elsif minute[:goal_scored] == 'away'
        scorer = Player.find_by(id: minute[:scorer])&.name
        assister = Player.find_by(id: minute[:assist])&.name
        away_score += 1
        event = 'Away Goal'
        commentary = goal_commentary.gsub('{team}', away_team).gsub('{assister}', assister).gsub('{scorer}', scorer)
      elsif minute[:chance_on_target] == 'home'
        event = 'Good chance'
        commentary = chance_tar_commentary.gsub('{team}', home_team).gsub('{player}', home_name)
      elsif minute[:chance_on_target] == 'away'
        event = 'Good chance'
        commentary = chance_tar_commentary.gsub('{team}', away_team).gsub('{player}', away_name)
      elsif minute[:chance_outcome] == 'home'
        event = 'Chance'
        commentary = chance_commentary.gsub('{team}', home_team).gsub('{player}', home_name)
      elsif minute[:chance_outcome] == 'away'
        event = 'Chance'
        commentary = chance_commentary.gsub('{team}', away_team).gsub('{player}', away_name)
      else
        event = ''
        team_names = [away_team, home_team]
        selected_team = team_names.sample
        commentary = general_commentary.gsub('{team}', selected_team)
      end

      Commentary.create(
        match_id: match_id,
        minute: time,
        commentary: commentary,
        event: event,
        home_score: home_score,
        away_score: away_score
      )
    end
  end
end
