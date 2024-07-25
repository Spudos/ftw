class ProcessTurnsheetJob < ApplicationJob
  queue_as :default

  def perform(selected_week)
    begin
      turnsheet = Turnsheet.new
      turnsheet.process_turnsheet(selected_week)
    rescue StandardError => e
      Error.create(
        error_type: 'RunMatchesJob',
        message: e.message
      )
    end
  end
end