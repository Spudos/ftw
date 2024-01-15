class Matches < ApplicationRecord
  def match_engine(params)
    # get the fixture list then iterate through it preparing the squads for each match
    fixture_list = get_fixtures_for_week(params)

    fixture_list.each do |fixture|
      match_info, match_squad = create_squad_for_game(fixture)
      match_squad_with_performance = calculate_player_performance(match_squad)
      squads_with_adjusted_performance = adjust_player_performance_by_tactic(match_squad_with_performance)
      save_player_match_data(squads_with_adjusted_performance, match_info)
      basic_team_totals = calculate_team_totals(squads_with_adjusted_performance)
      home_stadium_size = calculate_stadium_size(basic_team_totals)
      adjusted_team_totals = calculate_teams_with_stadium_effect(basic_team_totals, home_stadium_size)
      run_match_logic(adjusted_team_totals, squads_with_adjusted_performance, match_info)
    end
  end

  def run_match_logic(adjusted_team_totals, squads_with_adjusted_performance, match_info)
    home_list, away_list = compile_list_of_players(squads_with_adjusted_performance)
    home_top_5, away_top_5 = compile_list_of_top_5_players(home_list, away_list)

    minute_by_minute = []
    rand(90..98).times do |i|
      chance_result = calculate_chance_created(adjusted_team_totals, i)
      chance_on_target_result = calculate_if_chance_on_target(chance_result, adjusted_team_totals)
      goal_scored = calculate_goal_scored(chance_on_target_result, adjusted_team_totals)

      if goal_scored[:goal_scored] != 'none'
        assist = who_assisted(home_top_5, away_top_5, goal_scored)
        scorer = who_scored(home_top_5, away_top_5, assist, goal_scored)
      else
        assist = { assist: 'none' }
        scorer = { scorer: 'none' }
      end

      minute_by_minute << { **match_info, **chance_result, **chance_on_target_result, **goal_scored, **assist, **scorer }
    end
    run_end_of_match(home_list, away_list, minute_by_minute)
  end

  def run_end_of_match(home_list, away_list, minute_by_minute)
    detailed_match_summary = []
    match_summary = create_match_summary(minute_by_minute)
    possession = calc_possession(match_summary)
    man_of_the_match = select_man_of_the_match(home_list, away_list)
    detailed_match_summary << { **match_summary, **possession, **man_of_the_match }

    save_detailed_match_summary(detailed_match_summary)
    save_goal_and_assist_information(minute_by_minute)
    create_match_commentary(home_list, away_list, minute_by_minute)
  end

  private

  def get_fixtures_for_week(params)
    # gets the fixtures for the week then sends them into run_and_save_matches
    fixtures = Fixtures.where(week_number: params[:selected_week])

    fixture_list = []
    fixtures.each do |fixture|
      fixture_list << {
        id: fixture.id,
        club_home: fixture.home,
        club_away: fixture.away,
        week_number: fixture.week_number,
        competition: fixture.comp
      }
    end
    fixture_list
  end

  def create_squad_for_game(fixture)
    # create a hash of teams in the fixture to be played
    teams = {
      id: fixture[:id],
      week: fixture[:week_number],
      competition: fixture[:competition],
      club_home: fixture[:club_home],
      tactic_home: Tactic.find_by(abbreviation: fixture[:club_home])&.tactics,
      club_away: fixture[:club_away],
      tactic_away: Tactic.find_by(abbreviation: fixture[:club_away])&.tactics
    }

    # this populates the player_ids array for both teams with a list of players for the match
    player_ids = []
    teams.each_value do |team|
      player_ids += Selection.where(club: team).pluck(:player_id)
    end

    # this populates the match_squad for home and away with a list of full player details for the match
    match_squad = []
    id = fixture[:id]

    player_ids.each do |player_id|
      match_squad += Player.where(id: player_id)
    end
    return teams, match_squad
  end

  def calculate_player_performance(match_squad)
    players_array = []
    match_squad.each do |player|
      # get the tactic that team is using
      tactic = Tactic.find_by(abbreviation: player.club)&.tactics

      # create and return a hash with each players details including performance
      hash = {
        player_id: player.id,
        id: @id,
        club: player.club,
        player_name: player.name,
        total_skill: player.total_skill,
        tactic: tactic,
        player_position: player.position,
        player_position_detail: player.player_position_detail,
        match_performance: player.match_performance(player)
      }
      players_array << hash
    end
    players_array
  end

  def adjust_player_performance_by_tactic(match_squad_with_performance)
    # tactic name       dfc  mid  att  l,r  c
    # 1      passing    -5  +10  -0    0    0
    # 2      defensive  +15 -5   -10   0    0
    # 3      Attacking  -10 +5   +15   0    0
    # 4      Wide        0   0    0   +10  -10
    # 5      Narrow      0   0    0   -10  +10
    # 6      Direct     +5  -5   +5    0    0

    players = match_squad_with_performance

    players.each do |player|
      if player[:player_position_detail] == 'c'
        player[:match_performance] -= 10 if player[:tactic] == 4
        player[:match_performance] += 10 if player[:tactic] == 5
      elsif player[:player_position_detail] == 'r' || player[:player_position_detail] == 'l'
        player[:match_performance] += 10 if player[:tactic] == 4
        player[:match_performance] -= 10 if player[:tactic] == 5
      end

      if player[:player_position] == 'dfc'
        player[:match_performance] -= 5 if player[:tactic] == 1
        player[:match_performance] += 15 if player[:tactic] == 2
        player[:match_performance] -= 10 if player[:tactic] == 3
        player[:match_performance] += 5 if player[:tactic] == 6
      elsif player[:player_position] == 'mid'
        player[:match_performance] += 15 if player[:tactic] == 1
        player[:match_performance] -= 10 if player[:tactic] == 2
        player[:match_performance] += 15 if player[:tactic] == 3
        player[:match_performance] -= 5 if player[:tactic] == 6
      elsif player[:player_position] == 'att'
        player[:match_performance] -= 5 if player[:tactic] == 1
        player[:match_performance] -= 10 if player[:tactic] == 2
        player[:match_performance] += 10 if player[:tactic] == 3
        player[:match_performance] += 5 if player[:tactic] == 6
      end
    end
    squads_with_adjusted_peformance = players
  end

  def save_player_match_data(squads_with_adjusted_performance, match_info)
    id = match_info[:id]
    squads_with_adjusted_performance.each do |player|
      PlayerMatchData.create(
        match_id: id,
        player_id: player[:player_id],
        club: player[:club],
        name: Player.find_by(id: player[:player_id])&.name,
        player_position: Player.find_by(id: player[:player_id])&.position,
        player_position_detail: Player.find_by(id: player[:player_id])&.player_position_detail,
        match_performance: player[:match_performance]
      )
    end
  end

  def calculate_team_totals(squads_with_adjusted_performance)
    squads = squads_with_adjusted_performance

    home_team = squads.first[:club]
    away_team = squads.last[:club]

    home_dfc = 0
    home_mid = 0
    home_att = 0
    away_dfc = 0
    away_mid = 0
    away_att = 0

    squads.each do |player|
      case player[:player_position]
      when 'gkp', 'dfc'
        if player[:club] == home_team
          home_dfc += player[:match_performance]
        else
          away_dfc += player[:match_performance]
        end
      when 'mid'
        if player[:club] == home_team
          home_mid += player[:match_performance]
        else
          away_mid += player[:match_performance]
        end
      else
        if player[:club] == home_team
          home_att += player[:match_performance]
        else
          away_att += player[:match_performance]
        end
      end
    end

    totals = [
      {
        team: home_team,
        defense: home_dfc,
        midfield: home_mid,
        attack: home_att
      },
      {
        team: away_team,
        defense: away_dfc,
        midfield: away_mid,
        attack: away_att
      }
    ]
    totals
  end

  def calculate_stadium_size(basic_team_totals)
    club = Club.find_by(abbreviation: basic_team_totals.first[:team])
    stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

    stadium_size
  end

  def calculate_teams_with_stadium_effect(basic_team_totals, home_stadium_size)
    if home_stadium_size <= 10000
      stadium_effect = 0
    elsif home_stadium_size <= 20000
      stadium_effect = 2
    elsif home_stadium_size <= 30000
      stadium_effect = 3
    elsif home_stadium_size <= 40000
      stadium_effect = 4
    elsif home_stadium_size <= 50000
      stadium_effect = 5
    elsif home_stadium_size <= 60000
      stadium_effect = 6
    elsif home_stadium_size <= 70000
      stadium_effect = 7
    else
      stadium_effect = 10
    end

    basic_team_totals.first[:defense] += stadium_effect
    basic_team_totals.first[:midfield] += stadium_effect
    basic_team_totals.first[:attack] += stadium_effect

    basic_team_totals
  end

  def calculate_chance_created(adjusted_team_totals, i)
    random_number = rand(1..100)
    chance = adjusted_team_totals.first[:midfield] - adjusted_team_totals.last[:midfield]
    chance_outcome = ''

    if chance >= 0 && rand(0..100) < 16
      chance_outcome = 'home'
    elsif chance.negative? && rand(0..100) < 16
      chance_outcome = 'away'
    elsif random_number <= 5
      chance_outcome = 'home'
    elsif random_number > 5 && random_number <= 10
      chance_outcome = 'away'
    else
      chance_outcome = 'none'
    end

    chance_result = {
      minute: i,
      chance_outcome:
    }

    chance_result
  end

  def calculate_if_chance_on_target(chance_result ,adjusted_team_totals)
    home_attack = adjusted_team_totals.first[:attack]
    away_attack = adjusted_team_totals.last[:attack]
    chance_on_target = ''

    if chance_result[:chance_outcome] == 'home' && home_attack / 2 > rand(0..100)
      chance_on_target = 'home'
    elsif chance_result[:chance_outcome] == 'away' && away_attack / 2 > rand(0..100)
      chance_on_target = 'away'
    else
      chance_on_target = 'none'
    end
    {
      chance_on_target: chance_on_target
    }
  end

  def calculate_goal_scored(chance_on_target_result, adjusted_team_totals)
    home_attack = adjusted_team_totals.first[:attack]
    away_attack = adjusted_team_totals.last[:attack]
    goal_scored = ''

    if chance_on_target_result[:chance_on_target]  == 'home' && home_attack / 3 > rand(0..100)
      goal_scored = 'home'
    elsif chance_on_target_result[:chance_on_target] == 'away' && away_attack / 3 > rand(0..100)
      goal_scored = 'away'
    else
      goal_scored = 'none'
    end
    {
      goal_scored:
    }
  end

  def compile_list_of_players(squads_with_adjusted_performance)
    home_team = squads_with_adjusted_performance.first[:club]
    home_list = []
    away_list = []

    squads_with_adjusted_performance.each do |player|
      if player[:club] == home_team
        home_list << { player_id: player[:player_id], player_position: player[:player_position],match_performance: player[:match_performance] }
      else
        away_list << { player_id: player[:player_id], player_position: player[:player_position],match_performance: player[:match_performance] }
      end
    end
   return home_list, away_list
  end

  def compile_list_of_top_5_players(home_list, away_list)
    home_top_5 = home_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    away_top_5 = away_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    return home_top_5, away_top_5
  end

  def who_assisted(home_top_5, away_top_5, goal_scored)
    if goal_scored[:goal_scored] == 'home'
      assist = home_top_5.sample[:player_id]
    else
      assist = away_top_5.sample[:player_id]
    end
    { assist: }
  end

  def who_scored(home_top_5, away_top_5, assist, goal_scored)
    if goal_scored[:goal_scored] == 'home'
      scorer = home_top_5.reject { |player| player[:player_id] == assist }.sample[:player_id]
    else
      scorer = away_top_5.reject { |player| player[:player_id] == assist }.sample[:player_id]
    end
  
    while scorer == assist
      if goal_scored[:goal_scored] == 'home'
        scorer = home_top_5.reject { |player| player[:player_id] == assist }.sample[:player_id]
      else
        scorer = away_top_5.reject { |player| player[:player_id] == assist }.sample[:player_id]
      end
    end
  
    { scorer: scorer }
  end

  def create_match_summary(minute_by_minute)
    id = minute_by_minute.first[:id]
    week = minute_by_minute.first[:week]
    competition = minute_by_minute.first[:competition]
    club_home = minute_by_minute.first[:club_home]
    tactic_home = minute_by_minute.first[:tactic_home]
    club_away = minute_by_minute.first[:club_away]
    tactic_away = minute_by_minute.first[:tactic_away]
    chance_count_home = minute_by_minute.count { |chance| chance[:chance_outcome] == 'home' }
    chance_count_away = minute_by_minute.count { |chance| chance[:chance_outcome] == 'away' }
    chance_on_target_home = minute_by_minute.count { |chance| chance[:chance_on_target] == 'home' }
    chance_on_target_away = minute_by_minute.count { |chance| chance[:chance_on_target] == 'away' }
    goal_home = minute_by_minute.count { |chance| chance[:goal_scored] == 'home' }
    goal_away = minute_by_minute.count { |chance| chance[:goal_scored] == 'away' }

    match_summary = {
      id:,
      week:,
      competition:,
      club_home:,
      tactic_home:,
      club_away:,
      tactic_away:,
      chance_count_home:,
      chance_count_away:,
      chance_on_target_home:,
      chance_on_target_away:,
      goal_home:,
      goal_away:
    }
    match_summary
  end

  def calc_possession(match_summary)
    home_possession = (match_summary[:chance_count_home] / (match_summary[:chance_count_home] + match_summary[:chance_count_away]).to_f * 80).to_i
    away_possession = 100 - home_possession

    { home_possession:, away_possession:}
  end

  def select_man_of_the_match(home_list, away_list)
    home_man_of_the_match = home_list.max_by { |player| player[:match_performance] }[:player_id]
    away_man_of_the_match = away_list.max_by { |player| player[:match_performance] }[:player_id]

    { home_man_of_the_match:, away_man_of_the_match:}
  end

  def save_detailed_match_summary(detailed_match_summary)
    match_data = detailed_match_summary[0] # Access the first hash in the array

    match = Matches.new(
      match_id: match_data[:id].to_i,
      week_number: match_data[:week].to_i,
      competition: match_data[:competition],
      home_team: match_data[:club_home],
      tactic_home: match_data[:tactic_home],
      away_team: match_data[:club_away],
      tactic_away: match_data[:tactic_away],
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

  def save_goal_and_assist_information(minute_by_minute)
    minute_by_minute.each do |match_data|
      if match_data[:goal_scored] != 'none'
      match = GoalsAndAssistsByMatch.create(
        match_id: match_data[:id],
        week_number: match_data[:week],
        minute: match_data[:minute],
        assist: match_data[:assist],
        scorer: match_data[:scorer]
      )
      end
    end
  end

  def create_match_commentary(home_list, away_list, minute_by_minute)
    home_team = Club.find_by(abbreviation: minute_by_minute.first[:club_home])&.name
    away_team = Club.find_by(abbreviation: minute_by_minute.first[:club_away])&.name

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
      game_id = minute[:id]

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

      # Save the commentary to the commentaries table
      Commentary.create(
        game_id: game_id,
        minute: time,
        commentary: commentary,
        event: event,
        home_score: home_score,
        away_score: away_score
      )
    end
  end
end
