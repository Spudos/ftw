class Match::Names
  attr_reader :goal_scored, :home_top_5, :away_top_5

  def initialize(goal_scored, home_top_5, away_top_5)
    @goal_scored = goal_scored
    @home_top_5 = home_top_5
    @away_top_5 = away_top_5
  end

  def call
    if goal_scored[:goal_scored] != 'none'
      assist = Match::Assisted.new(home_top_5, away_top_5, goal_scored).call
      scorer = Match::Scored.new(home_top_5, away_top_5, assist, goal_scored).call
    else
      assist = { assist_id: 'none' }
      scorer = { scorer: 'none' }
    end

    return assist, scorer
  end
end