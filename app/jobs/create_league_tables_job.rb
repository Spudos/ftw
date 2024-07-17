class CreateLeagueTablesJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      league = League.new
      league.create_tables(params)
    rescue StandardError => e
      logger = Logger.new('error.log')
      logger.error(e.message)
      puts "ERROR: An error occurred while processing the job: #{e.message}"
    end
  end
end
