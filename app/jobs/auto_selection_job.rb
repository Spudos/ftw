class AutoSelectionJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      selection = Selection.new
      selection.auto_selection(params)
    rescue StandardError => e
      Error.create(
        error_type: 'AutoSelectionJob',
        message: e.message
      )
    end
  end
end
