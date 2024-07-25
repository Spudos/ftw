class UpgradeAdminJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      turn = Turn.new
      turn.process_upgrade_admin(params)
    rescue StandardError => e
      Error.create(
        error_type: 'UpgradeAdminJob',
        message: e.message
      )
    end
  end
end
