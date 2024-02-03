class Match::Assisted
  attr_reader :home_top, :away_top, :goal_scored

  def initialize(home_top, away_top, goal_scored)
    @home_top = home_top
    @away_top = away_top
    @goal_scored = goal_scored
  end

  def call
    if @home_top.nil? || @away_top.nil? || @goal_scored.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    if goal_scored[:goal_scored] == 'home'
      assist = home_top.sample[:player_id]
    else
      assist = away_top.sample[:player_id]
    end
    { assist: }
  end
end