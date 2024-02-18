class Turn < ApplicationRecord
  def process_turn_actions(params)
    if params[:week].present? && Message.find_by(action_id: params[:week]).nil?
      Turn::TurnActions.new(params[:week]).call
      Turn::PlayerUpdates.new(params[:week]).call
      Turn::UpgradeAdmin.new(params[:week]).call
      Message.create(action_id: params[:week], week: params[:week], club_id: '999', var1: "week #{params[:week]} processed")
    else
      if params[:week].nil?
        raise 'Please select a week before trying to process turn actions.'
      else
        raise 'Week has already been processed.'
      end
    end
  end
end
