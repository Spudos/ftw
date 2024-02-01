class Match::Assisted
  attr_reader :home_top, :away_top, :goal_scored

  def initialize(home_top, away_top, goal_scored)
    @home_top = home_top
    @away_top = away_top
    @goal_scored = goal_scored
  end

  def call
    if goal_scored[:goal_scored] == 'home'
      assist = home_top.sample[:player_id]
    else
      assist = away_top.sample[:player_id]
    end
    { assist: }
  end
end