class Match < ApplicationRecord
  def run_matches(params)
    fixture_list = fixtures_for_week(params)

    fixture_list.each do |fixture|
      match_info, match_squad = Match::SquadCreator.new(fixture).squad_for_game
      squads_with_performance = player_performance(match_squad)
      squads_with_tactics = Match::TacticAdjustment.new(squads_with_performance).player_performance_by_tactic
      save_player_match_data(squads_with_tactics, match_info)
      player_fitness(squads_with_tactics, match_info)
      totals = team_totals(squads_with_performance)
      home_stadium = stadium_size(totals)
      totals_with_stadium = teams_with_stadium_effect(totals, home_stadium)
      totals_with_aggression = totals_with_aggression_effect(totals_with_stadium)
      run_match_logic(totals_with_aggression, squads_with_performance, match_info)
    end
  end

  def run_match_logic(final_team_totals, squads_with_performance, match_info)
    home_list, away_list = list_of_players(squads_with_performance)
    home_top_5, away_top_5 = list_of_top_5_players(home_list, away_list)

    minute_by_minute = []
    rand(90..98).times do |i|
      chance_result = chance_created(final_team_totals, i)
      chance_on_target_result = if_chance_on_target(chance_result, final_team_totals)
      goal_scored = goal_scored(chance_on_target_result, final_team_totals)

      if goal_scored[:goal_scored] != 'none'
        assist = assisted(home_top_5, away_top_5, goal_scored)
        scorer = scored(home_top_5, away_top_5, assist, goal_scored)
      else
        assist = { assist_id: 'none' }
        scorer = { scorer: 'none' }
      end

      minute_by_minute << { **match_info, **chance_result, **chance_on_target_result, **goal_scored, **assist, **scorer }
    end
    run_end_of_match(home_list, away_list, minute_by_minute)
  end

  def run_end_of_match(home_list, away_list, minute_by_minute)
    detailed_match_summary = []
    match_summary = match_summary(minute_by_minute)
    possession = possession(match_summary)
    man_of_the_match = man_of_the_match(home_list, away_list)
    detailed_match_summary << { **match_summary, **possession, **man_of_the_match }

    save_detailed_match_summary(detailed_match_summary)
    save_goal_and_assist_information(minute_by_minute)
    Match::MatchCommentary.new(home_list, away_list, minute_by_minute).match_commentary
  end

  private

  def fixtures_for_week(params)
    if params[:competition] == nil
      fixtures = Fixture.where(week_number: params[:selected_week])
    else
      fixtures = Fixture.where(week_number: params[:selected_week], comp: params[:competition])
    end

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

  def player_performance(match_squad)
    players_array = []
    match_squad.each do |player|
      tactic = Tactic.find_by(abbreviation: player.club)&.tactics

      hash = {
        player_id: player.id,
        id: @id,
        club: player.club,
        player_name: player.name,
        total_skill: player.total_skill,
        tactic:,
        player_position: player.position,
        player_position_detail: player.player_position_detail,
        match_performance: player.match_performance(player)
      }
      players_array << hash
    end
    players_array
  end

  def save_player_match_data(squads_with_performance, match_info)
    id = match_info[:id]
    competition = match_info[:competition]

    squads_with_performance.each do |player|
      Performance.create(
        match_id: id,
        player_id: player[:player_id],
        club: player[:club],
        name: Player.find_by(id: player[:player_id])&.name,
        player_position: Player.find_by(id: player[:player_id])&.position,
        player_position_detail: Player.find_by(id: player[:player_id])&.player_position_detail,
        match_performance: player[:match_performance],
        competition:
      )
    end
  end

  def player_fitness(squads_with_performance, match_info)
    squads_with_performance.each do |player|
      player_record = Player.find_by(id: player[:player_id])
      player_fitness = player_record&.fitness
      player_fitness -= rand(3..8)

      if player[:player_position] == 'gkp'
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:dfc_aggression_home]
        else
          player_fitness -= match_info[:dfc_aggression_away]
        end
      elsif player[:player_position] == 'dfc'
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:dfc_aggression_home]
        else
          player_fitness -= match_info[:dfc_aggression_away]
        end
      elsif player[:player_position] == 'mid'
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:mid_aggression_home]
        else
          player_fitness -= match_info[:mid_aggression_away]
        end
      else
        if player_record[:club] == match_info[:club_home]
          player_fitness -= match_info[:att_aggression_home]
        else
          player_fitness -= match_info[:att_aggression_away]
        end
      end

      player_fitness = 0 if player_fitness < 0

      player_record.update(fitness: player_fitness) if player_record
    end
  end

  def team_totals(squads_with_performance)
    squads = squads_with_performance

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

  def stadium_size(team_totals)
    club = Club.find_by(abbreviation: team_totals.first[:team])
    stadium_size = club.stand_n_capacity + club.stand_s_capacity + club.stand_e_capacity + club.stand_w_capacity

    stadium_size
  end

  def teams_with_stadium_effect(team_totals, home_stadium_size)
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

    team_totals.first[:defense] += stadium_effect
    team_totals.first[:midfield] += stadium_effect
    team_totals.first[:attack] += stadium_effect

    team_totals
  end

  def totals_with_aggression_effect(totals_with_stadium)
    totals_with_aggression = []

    totals_with_stadium.each do |team|
      hash = {
        team: team[:team],
        defense: team[:defense] + Tactic.find_by(abbreviation: team[:team])&.dfc_aggression * 5,
        midfield: team[:midfield] + Tactic.find_by(abbreviation: team[:team])&.mid_aggression * 5,
        attack: team[:attack] + Tactic.find_by(abbreviation: team[:team])&.att_aggression * 5
      }
      totals_with_aggression << hash
    end
    return totals_with_aggression
  end

  def chance_created(final_team_totals, i)
    random_number = rand(1..100)
    chance = final_team_totals.first[:midfield] - final_team_totals.last[:midfield]
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

  def if_chance_on_target(chance_result ,adjusted_team_totals)
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

  def goal_scored(chance_on_target_result, adjusted_team_totals)
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

  def list_of_players(squads_with_adjusted_performance)
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

  def list_of_top_5_players(home_list, away_list)
    home_top_5 = home_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    away_top_5 = away_list.reject { |player| player[:player_position] == "gkp" }
                         .sort_by { |player| -player[:match_performance] }
                         .first(5)
    return home_top_5, away_top_5
  end

  def assisted(home_top_5, away_top_5, goal_scored)
    if goal_scored[:goal_scored] == 'home'
      assist = home_top_5.sample[:player_id]
    else
      assist = away_top_5.sample[:player_id]
    end
    { assist: }
  end

  def scored(home_top_5, away_top_5, assist, goal_scored)
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

    { scorer: }
  end

  def match_summary(minute_by_minute)
    match_summary = {
      id: minute_by_minute.first[:id],
      week: minute_by_minute.first[:week],
      competition: minute_by_minute.first[:competition],
      club_home: minute_by_minute.first[:club_home],
      tactic_home: minute_by_minute.first[:tactic_home],
      dfc_aggression_home: minute_by_minute.first[:dfc_aggression_home],
      mid_aggression_home: minute_by_minute.first[:mid_aggression_home],
      att_aggression_home: minute_by_minute.first[:att_aggression_home],
      club_away: minute_by_minute.first[:club_away],
      tactic_away: minute_by_minute.first[:tactic_away],
      dfc_aggression_away: minute_by_minute.first[:dfc_aggression_away],
      mid_aggression_away: minute_by_minute.first[:mid_aggression_away],
      att_aggression_away: minute_by_minute.first[:att_aggression_away],
      chance_count_home: minute_by_minute.count { |chance| chance[:chance_outcome] == 'home' },
      chance_count_away: minute_by_minute.count { |chance| chance[:chance_outcome] == 'away' },
      chance_on_target_home: minute_by_minute.count { |chance| chance[:chance_on_target] == 'home' },
      chance_on_target_away: minute_by_minute.count { |chance| chance[:chance_on_target] == 'away' },
      goal_home: minute_by_minute.count { |chance| chance[:goal_scored] == 'home' },
      goal_away: minute_by_minute.count { |chance| chance[:goal_scored] == 'away' }
    }
    match_summary
  end

  def possession(match_summary)
    home_possession = (match_summary[:chance_count_home] / (match_summary[:chance_count_home] + match_summary[:chance_count_away]).to_f * 80).to_i
    away_possession = 100 - home_possession

    { home_possession:, away_possession:}
  end

  def man_of_the_match(home_list, away_list)
    home_man_of_the_match = home_list.max_by { |player| player[:match_performance] }[:player_id]
    away_man_of_the_match = away_list.max_by { |player| player[:match_performance] }[:player_id]

    { home_man_of_the_match:, away_man_of_the_match:}
  end

  def save_detailed_match_summary(detailed_match_summary)
    match_data = detailed_match_summary[0] # Access the first hash in the array

    match = Match.new(
      match_id: match_data[:id].to_i,
      week_number: match_data[:week].to_i,
      competition: match_data[:competition],
      home_team: match_data[:club_home],
      tactic_home: match_data[:tactic_home],
      dfc_aggression_home: match_data[:dfc_aggression_home],
      mid_aggression_home: match_data[:mid_aggression_home],
      att_aggression_home: match_data[:att_aggression_home],
      away_team: match_data[:club_away],
      tactic_away: match_data[:tactic_away],
      dfc_aggression_away: match_data[:dfc_aggression_away],
      mid_aggression_away: match_data[:mid_aggression_away],
      att_aggression_away: match_data[:att_aggression_away],
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
        match = Goal.create(
          match_id: match_data[:id],
          week_number: match_data[:week],
          minute: match_data[:minute],
          assist_id: match_data[:assist],
          scorer_id: match_data[:scorer],
          competition: match_data[:competition]
        )
      end
    end
  end
end
