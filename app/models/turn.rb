class Turn < ApplicationRecord
  def process_turn_actions(params)
    if params[:week].present? && Message.find_by(action_id: "#{params[:week]}TTA").nil?
      Turn::TurnActions.new(params[:week]).call
      Turn::TransferActions.new(params[:week]).call
      Message.create(action_id: "#{params[:week]}TTA", week: params[:week], club_id: '999', var1: "week #{params[:week]} Turn/Transfer Actions processed")
    else
      if params[:week].nil?
        raise 'Please select a week before trying to process Turn and Transfer Actions.'
      else
        raise 'Turn actions for that week have already been processed.'
      end
    end
  end

  def process_player_updates(params)
    if params[:week].present? && Message.find_by(action_id: "#{params[:week]}PU").nil?
      Turn::PlayerUpdates.new(params[:week]).call
      Message.create(action_id: "#{params[:week]}PU", week: params[:week], club_id: '999', var1: "week #{params[:week]} Player Updates processed")
    else
      if params[:week].nil?
        raise 'Please select a week before trying to process Player Updates.'
      else
        raise 'Player Updates for that week have already been processed.'
      end
    end
  end

  def process_upgrade_admin(params)
    if params[:week].present? && Message.find_by(action_id: "#{params[:week]}UA").nil?
      Turn::UpgradeAdmin.new(params[:week]).call
      Message.create(action_id: "#{params[:week]}UA", week: params[:week], club_id: '999', var1: "week #{params[:week]} Upgrade Admin processed")
    else
      if params[:week].nil?
        raise 'Please select a week before trying to process Upgrade Admin.'
      else
        raise 'Upgrade Admin for that week has already been processed.'
      end
    end
  end

  def process_club_updates(params)
    if params[:week].present? && Message.find_by(action_id: "#{params[:week]}CU").nil?
      Turn::ClubUpdates.new(params[:week]).call
      Message.create(action_id: "#{params[:week]}CU", week: params[:week], club_id: '999', var1: "week #{params[:week]} Club Updates processed")
    else
      if params[:week].nil?
        raise 'Please select a week before trying to process Upgrade Admin.'
      else
        raise 'Club Updates for that week has already been processed.'
      end
    end
  end

  def process_article_updates(params)
    if params[:week].present? && Message.find_by(action_id: "#{params[:week]}ARU").nil?
      Turn::ArticleUpdates.new(params[:week]).call
      Message.create(action_id: "#{params[:week]}ARU", week: params[:week], club_id: '999', var1: "week #{params[:week]} Article Updates processed")
    else
      if params[:week].nil?
        raise 'Please select a week before trying to process Upgrade Admin.'
      else
        raise 'Article Admin for that week has already been processed.'
      end
    end
  end
end
