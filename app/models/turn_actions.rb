class TurnActions < ApplicationRecord
  def process_turn_actions(params, turn)
    if params.present? && !turn.turn_actions
      TurnActions::TurnActionMethods.new(params).call
      turn.update(turn_actions: true)
    elsif params.nil?
      Error.create(error_type: 'turn_actions', message: 'Please select a week before trying to process Turn Actions.')
    else
      Error.create(error_type: 'turn_actions', message: 'Turn actions for that week have already been processed.')
    end
  end
end
