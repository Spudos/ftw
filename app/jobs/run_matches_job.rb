class RunMatchesJob < ApplicationJob
  queue_as :default

  def perform(selected_week, competition)
    begin
      match = Match.new
      match.run_matches(selected_week, competition)
    rescue StandardError => e
      logger = Logger.new('error.log')
      logger.error(e.message)
      puts "ERROR: An error occurred while processing the job: #{e.message}"
      Error.create(
        error_type: 'RunMatchesJob',
        message: e.message
      )
    end
  end
end
