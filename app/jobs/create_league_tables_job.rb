class CreateLeagueTablesJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      league = League.new
      league.create_tables(params)
    rescue StandardError => e
      Error.create(
        error_type: 'CreateLeagueTablesJob',
        message: e.message
      )
    end
  end
end
