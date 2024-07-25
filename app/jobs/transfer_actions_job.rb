class TransferActionsJob < ApplicationJob
  queue_as :default

  def perform(selected_week)
    begin
      transfer = Transfer.new
      transfer.process_transfer_actions(selected_week)
    rescue StandardError => e
      Error.create(
        error_type: 'TransferActionsJob',
        message: e.message
      )
    end
  end
end