class AutoSelectionJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      selection = Selection.new
      selection.auto_selection(params)
    rescue StandardError => e
      logger = Logger.new('error.log')
      logger.error(e.message)
      puts "ERROR: An error occurred while processing the job: #{e.message}"
    end
  end
end
