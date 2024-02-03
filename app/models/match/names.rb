class Match::Names
  attr_reader :goal_scored, :home_top, :away_top

  def initialize(goal_scored, home_top, away_top)
    @goal_scored = goal_scored
    @home_top = home_top
    @away_top = away_top
  end

  def call
    if goal_scored.nil? || home_top.nil? || away_top.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    if goal_scored[:goal_scored] != 'none'
      assist = Match::Assisted.new(home_top, away_top, goal_scored).call
      scorer = Match::Scored.new(home_top, away_top, assist, goal_scored).call
    else
      assist = { assist: 'none' }
      scorer = { scorer: 'none' }
    end

    return assist, scorer
  end
end
