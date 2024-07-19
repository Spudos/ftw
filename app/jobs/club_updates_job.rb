class ClubUpdatesJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      turn = Turn.new
      turn.process_club_updates(params)
    rescue StandardError => e
      logger = Logger.new('error.log')
      logger.error(e.message)
      puts "ERROR: An error occurred while processing the job: #{e.message}"
      Error.create(
        error_type: 'ClubUpdatesJob',
        error: e.message
      )
    end
  end
end
