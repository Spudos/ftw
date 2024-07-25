class TransferUpdatesJob < ApplicationJob
  queue_as :default

  def perform(selected_week)
    begin
      transfer = Transfer.new
      transfer.process_transfer_updates(selected_week)
    rescue StandardError => e
      Error.create(
        error_type: 'TransferUpdatesJob',
        message: e.message
      )
    end
  end
end