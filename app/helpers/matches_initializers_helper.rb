module MatchesInitializersHelper
  def initialize_sqd(fixture)
    @match_id = fixture[:match_id].to_i
    @week_number = fixture[:week_number].to_i
    @club_home = fixture[:club_home]
    @club_awayay = fixture[:club_awayay]

    player_ids_home = Selection.where(club: @club_home).pluck(:player_id)
    player_ids_away = Selection.where(club: @club_awayay).pluck(:player_id)

    @sqd_home = Player.where(id: player_ids_home)
    @sqd_away = Player.where(id: player_ids_away)
  end

  def initialize_squad_pl
    @sqd_pl_home = sqd_pl(@sqd_home)
    @sqd_pl_away = sqd_pl(@sqd_away)
  end

  def initialize_team_total
    @dfc_home, @mid_home, @att_home = tm_total(@sqd_pl_home)
    @dfc_away, @mid_away, @att_away = tm_total(@sqd_pl_away)
  end

  def initialize_team_chance_val
    @away_mod = (@mid_away + (@att_away * 0.50)) + rand(-20..20)
    @home_mod = (@mid_home + (@att_home * 0.50)) + rand(-20..20)
  end

  def initialize_chance?
    @chance_res = cha?
  end

  def initialize_chance_count
    chance_count
  end

  def initialize_chance_on_target
    chance_on_target(@att_home, @att_away)
  end

  def initialize_goal_scored?(i)
    goal_scored?(@att_home, @att_away, i)
  end

  def initialize_build_results(i)

    @res <<
      {
        game_id: @match_id,
        minute: i + 1,
        event: @event,
        commentary: @commentary
      }
  end

  def initialize_possessionession
    calc_possessionession
  end

  def initialize_man_of_the_match
    @man_of_the_match_home = select_man_of_the_match(@sqd_pl_home)
    @man_of_the_match_away = select_man_of_the_match(@sqd_pl_away)
  end

  def initialize_commentary
    home_team = Club.find_by(abbreviation: @club_home)&.name
    away_team = Club.find_by(abbreviation: @club_awayay)&.name
    scorer = Player.find_by(id: @goal[:scorer])&.name
    assister = Player.find_by(id: @goal[:assist])&.name
    general_commentary = Template.random_match_general_commentary
    chance_commentary = Template.random_match_chance_commentary
    chance_tar_commentary = Template.random_match_chance_tar_commentary
    goal_commentary = Template.random_match_goal_commentary
    home_name = @sqd_home.select { |player| player.position != "gkp" }.map(&:name)
    away_name = @sqd_away.select { |player| player.position != "gkp" }.map(&:name)

    if @goal_scored == 'home goal'
      @event = 'Home Goal'
      @commentary = goal_commentary.gsub('{team}', home_team).gsub('{assister}', assister).gsub('{scorer}', scorer).gsub('{player}', home_name.sample)
    elsif @goal_scored == 'away goal'
      @event = 'Away Goal'
      @commentary = goal_commentary.gsub('{team}', away_team).gsub('{assister}', assister).gsub('{scorer}', scorer).gsub('{player}', away_name.sample)
    elsif @chance_res == 'home' && @chance_on_target == 'home'
      @event = 'Good chance'
      @commentary = chance_tar_commentary.gsub('{team}', home_team).gsub('{player}', home_name.sample)
    elsif @chance_res == 'away' && @chance_on_target == 'away'
      @event = 'Good chance'
      @commentary = chance_tar_commentary.gsub('{team}', away_team).gsub('{player}', away_name.sample)
    elsif @chance_res == 'home'
      @event = 'Chance'
      @commentary = chance_commentary.gsub('{team}', home_team).gsub('{player}', home_name.sample)
    elsif @chance_res == 'away'
      @event = 'Chance'
      @commentary = chance_commentary.gsub('{team}', away_team).gsub('{player}', away_name.sample)
    else
      @event = ''
      team_names = [away_team, home_team]
      selected_team = team_names.sample
      @commentary = general_commentary.gsub('{team}', selected_team)
    end
  end
end
