class PreTurnAdminJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      turnsheet = Turnsheet.new
      turnsheet.process_turnsheet(params)

      turn = Turn.find_by(week: params)

      turn_actions = TurnActions.new
      turn_actions.process_turn_actions(params, turn)

      transfer = Transfer.new
      transfer.process_transfer_actions(params, turn)
    rescue StandardError => e
      Error.create(
        error_type: 'PreTurnAdminJob',
        message: e.message
      )
    end
  end
end
