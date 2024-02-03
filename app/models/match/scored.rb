class Match::Scored
  attr_reader :home_top, :away_top, :assist, :goal_scored

  def initialize(home_top, away_top, assist, goal_scored)
    @home_top = home_top
    @away_top = away_top
    @assist = assist
    @goal_scored = goal_scored
  end

  def call
    if @home_top.nil? || @away_top.nil? || @assist.nil? || @goal_scored.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end
    
    if goal_scored[:goal_scored] == 'home'
      scorer = home_top.reject { |player| player[:player_id] == assist[:assist] }.sample[:player_id]
    else
      scorer = away_top.reject { |player| player[:player_id] == assist[:assist] }.sample[:player_id]
    end

    while scorer == assist
      if goal_scored[:goal_scored] == 'home'
        scorer = home_top.reject { |player| player[:player_id] == assist[:assist] }.sample[:player_id]
      else
        scorer = away_top.reject { |player| player[:player_id] == assist[:assist] }.sample[:player_id]
      end
    end

    { scorer: }
  end
end
