class Match::Scored
  attr_reader :home_top_5, :away_top_5, :assist, :goal_scored

  def initialize(home_top_5, away_top_5, assist, goal_scored)
    @home_top_5 = home_top_5
    @away_top_5 = away_top_5
    @assist = assist
    @goal_scored = goal_scored
  end

  def call
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
end