class RunMatchesJob < ApplicationJob
  queue_as :default

  def perform(selected_week, competition)
    begin
      match = Match.new
      match.run_matches(selected_week, competition)
    rescue StandardError => e
      logger = Logger.new('error.log')
      logger.error(e.message)
      flash.now[:alert] = "An error occurred while processing the job: #{e.message}"
    end
  end
end
