class MatchesJob < ApplicationJob
  queue_as :default

  def perform(selected_week)
    begin
      Processing.create(message: "#{selected_week}FM")

      selection = Selection.new
      selection.auto_selection(selected_week)

      match = Match.new
      match.run_matches(selected_week, nil)
    rescue StandardError => e
      logger = Logger.new('error.log')
      logger.error(e.message)
      puts "ERROR: An error occurred while processing the job: #{e.message}"
      Error.create(
        error_type: 'MatchesJob',
        message: e.message
      )
    end
  end
end
