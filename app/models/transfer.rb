class Transfer < ApplicationRecord
  def process_transfer_actions(params, turn)
    if params.present? && !turn.transfer_actions
      Transfer::TransferActions.new(params).call
      turn.update(transfer_actions: true)
    elsif params.nil?
      Error.create(error_type: 'transfer_action', message: 'Please select a week before trying to process Turn and Transfer Actions.')
    else
      Error.create(error_type: 'transfer_action', message: 'Turn actions for that week have already been processed.')
    end
  end

  def process_transfer_updates(params, turn)
    if params.present? && !turn.transfer_update
      Transfer::TransferUpdates.new(params).call
      turn.update(transfer_update: true)
    elsif params.nil?
      Error.create(error_type: 'transfer_update', message: 'Please select a week before trying to process Turn and Transfer Actions.')
    else
      Error.create(error_type: 'transfer_update', message: 'Turn actions for that week have already been processed.')
    end
  end
end
#------------------------------------------------------------------------------
# Message
#
# Name       SQL Type             Null    Primary Default
# ---------- -------------------- ------- ------- ----------
# id         INTEGER              false   true              
# week       INTEGER              true    false             
# club       varchar              true    false             
# var1       varchar              true    false             
# var2       varchar              true    false             
# created_at datetime(6)          false   false             
# updated_at datetime(6)          false   false             
# action_id  varchar              true    false             
#
#------------------------------------------------------------------------------
