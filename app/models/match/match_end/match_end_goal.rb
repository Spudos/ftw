class Match::MatchEnd::MatchEndGoal
  attr_reader :fixture_attendance, :summary

  def initialize(fixture_attendance, summary)
    @fixture_attendance = fixture_attendance
    @summary = summary
  end

  def call
    if @fixture_attendance.nil? || @summary.nil?
      raise StandardError, "There was an error in the #{self.class.name} class"
    end

    goal_upload = summarise_goals

    goal_attributes = goal_upload.to_a.map(&:as_json)
    Goal.upsert_all(goal_attributes)
  end

  private

  def summarise_goals
    goal_info = []

    fixture_attendance.each do |record|
      summary.each do |minute|
        if record[:club_home] == minute[1][0][:club_id] && minute[6][:goal_scored] != 'none'
          goal_info << {
            match_id: record[:id],
            week_number: record[:week_number],
            minute: minute[0],
            assist_id: minute[7][:assist],
            scorer_id: minute[7][:scorer],
            competition: record[:competition]
          }
        end
      end
    end

    goal_info
  end
end
