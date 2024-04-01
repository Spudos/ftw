class RunMatchesJob < ApplicationJob
  queue_as :default

  def perform(selected_week, competition)
    match = Match.new
    match.run_matches(selected_week, competition)
  end
end
