class RunMatchesJob < ApplicationJob
  queue_as :default

  def perform(selected_week, competition)
    begin
      match = Match.new
      match.run_matches(selected_week, competition)
    rescue StandardError => e
      Error.create(
        error_type: 'RunMatchesJob',
        message: e.message
      )
    end
  end
end
