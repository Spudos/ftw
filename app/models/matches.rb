class Matches < ApplicationRecord
  def match_engine(params)
    # get the fixture list then iterate through it preparing the squads for each match
    fixture_list = get_fixtures_for_week(params)

    fixture_list.each do |fixture|
      match_squad = create_squad_for_game(fixture)
      match_squad_with_performance = calculate_player_performance(match_squad)
      squads_with_adjusted_performance = adjust_player_performance_by_tactic(match_squad_with_performance)
      basic_team_totals = calculate_team_totals(squads_with_adjusted_performance)
      home_stadium_size = calculate_stadium_size(basic_team_totals)
      adjusted_team_totals = calculate_teams_with_stadium_effect(basic_team_totals, home_stadium_size)
      run_match_logic(adjusted_team_totals, squads_with_adjusted_performance)
    end
  end

  def run_match_logic(adjusted_team_totals, squads_with_adjusted_performance)
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

      minute_by_minute << { **chance_result, **chance_on_target_result, **goal_scored, **assist, **scorer }
      
      run_end_of_match(home_list, away_list, minute_by_minute)
    end
  end

  def run_end_of_match(home_list, away_list, minute_by_minute)
    binding.pry
  end

  private

  def get_fixtures_for_week(params)
    # gets the fixtures for the week then sends them into run_and_save_matches
    fixtures = Fixtures.where(week_number: params[:selected_week])

    fixture_list = []
    fixtures.each do |fixture|
      fixture_list << {
        match_id: fixture.match_id,
        club_home: fixture.home,
        club_away: fixture.away,
        week_number: fixture.week_number
      }
    end
    fixture_list
  end

  def create_squad_for_game(fixture)
    # create a list of teams in the fixture to be played
    teams = [fixture[:club_home], fixture[:club_away]]

    # this populates the player_ids array for both teams with a list of players for the match
    player_ids = []
    teams.each do |team|
      player_ids += Selection.where(club: team).pluck(:player_id)
    end

    # this populates the match_squad for home and away with a list of full player details for the match
    match_squad = []
    player_ids.each do |player_id|
      match_squad += Player.where(id: player_id)
    end
    match_squad
  end

  def calculate_player_performance(match_squad)
    players_array = []
    match_squad.each do |player|
      # get the tactic that team is using
      tactic = Tactic.find_by(abbreviation: player.club)&.tactics

      # create and return a hash with each players details including performance
      hash = {
        player_id: player.id,
        match_id: @match_id,
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
      if player[:match_performance] == 'c'
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

  # ----------------------------------------------------------------

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

    if chance_on_target_result == 'home' && home_attack / 3 > rand(0..100)
      goal_scored = 'home'
    elsif chance_on_target_result == 'away' && away_attack / 3 > rand(0..100)
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
    if goal_scored == 'home'
      assist = home_top_5.sample[:player_id]
    else
      assist = away_top_5.sample[:player_id]
    end

    return assist
  end

  def who_scored(home_top_5, away_top_5, assist, goal_scored)
    if goal_scored == 'home'
      scorer = home_top_5.reject { |player| player[:player_id] == assist[:player_id] }.sample[:player_id]
    else
      scorer = away_top_5.reject { |player| player[:player_id] == assist[:player_id] }.sample[:player_id]
    end

    scorer
  end
end
