module MatchesEndOfGameHelper
  def calc_possessionession
    @home_possession = (@chance_count_home / (@chance_count_home + @chance_count_away.to_f) * 80).to_i
    @away_possession = 100 - @home_possession.to_i
  end

  def select_man_of_the_match(sqd_pl)
    sqd_pl.max_by { |player| player[:match_performance] }[:id]
  end

  def initalize_save
    match = Matches.new(
      match_id: @match_id,
      week_number: @week_number,
      home_team: @club_home,
      away_team: @club_awayay,
      home_possession: @home_possession,
      away_possession: @away_possession,
      home_chance: @chance_count_home,
      away_chance: @chance_count_away,
      home_chance_on_target: @chance_on_target_home,
      away_chance_on_target: @chance_on_target_away,
      home_goals: @goal_home,
      away_goals: @goal_away,
      home_man_of_the_match: @man_of_the_match_home,
      away_man_of_the_match: @man_of_the_match_away,
    )

    if match.save
      puts "Match data saved successfully."
    else
      puts "Failed to save match data."
    end
  end
end