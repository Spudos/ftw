class Match::Assisted
  attr_reader :home_top_5, :away_top_5, :goal_scored

  def initialize(home_top_5, away_top_5, goal_scored)
    @home_top_5 = home_top_5
    @away_top_5 = away_top_5
    @goal_scored = goal_scored
  end

  def call
    if goal_scored[:goal_scored] == 'home'
      assist = home_top_5.sample[:player_id]
    else
      assist = away_top_5.sample[:player_id]
    end
    { assist: }
  end
end