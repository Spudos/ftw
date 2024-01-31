class Match::SaveGoalAndAssistInformation
  attr_reader :minute_by_minute

  def initialize(minute_by_minute)
    @minute_by_minute = minute_by_minute
  end

  def save
    minute_by_minute.each do |match_data|
      if match_data[:goal_scored] != 'none'
        match = Goal.create(
          match_id: match_data[:id],
          week_number: match_data[:week],
          minute: match_data[:minute],
          assist_id: match_data[:assist],
          scorer_id: match_data[:scorer],
          competition: match_data[:competition]
        )
      end
    end
  end
end
