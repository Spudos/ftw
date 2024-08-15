class Match::MinuteByMinute::MinuteByMinuteNames
  attr_reader :minute_by_minute_scored, :selection_complete, :match_team

  def initialize(minute_by_minute_scored, selection_complete, match_team)
    @minute_by_minute_scored = minute_by_minute_scored
    @selection_complete = selection_complete
    @match_team = match_team
  end

  def call
    if @minute_by_minute_scored.nil? || @match_team.nil? || @selection_complete.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    if minute_by_minute_scored[:goal_scored] == 'none'
      { assist: 'none', scorer: 'none' }
    else
      club_id = who_scored

      player_list = get_player_list(club_id)

      get_scorer_assist(player_list)
    end
  end

  private

  def who_scored
    team_who_scored = minute_by_minute_scored[:goal_scored]

    if team_who_scored == 'home'
      club_id = match_team[0][:club_id]
    elsif team_who_scored == 'away'
      club_id = match_team[1][:club_id]
    end

    club_id
  end

  def get_player_list(club_id)
    player_list = []

    selection_complete.each do |player|
      next if player[:club_id] != club_id

      hash = { player_id: player[:player_id],
               player_name: player[:name],
               player_position: player[:position] }

      hash[:performance] = if player[:position] == 'att'
                             player[:performance] + 20
                           else
                             player[:performance]
                           end
      player_list << hash
    end

    player_list
  end

  def get_scorer_assist(player_list)
    sorted_player_list = player_list.sort_by { |player| player[:performance] }.last(5).reverse

    scorer = sorted_player_list.sample[:player_id]

    remaining_players = sorted_player_list.reject { |player| player[:player_id] == scorer }

    assist = remaining_players.sample[:player_id]

    { assist:, scorer: }
  end
end
