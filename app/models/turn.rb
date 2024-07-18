class Turn < ApplicationRecord
  # def initialize
  #   @actions = Message.where("action_id IN (\"#{params[:week]}TA\", \"#{params[:week]}PU\")")
  # end

  def process_turn_actions(params)
    if params[:week].present? && Processing.find_by(message: "#{params[:week]}TA").nil?
      Turn::TurnActions.new(params[:week]).call
      Turn::TransferActions.new(params[:week]).call
      Processing.create(message: "#{params[:week]}TA")
    else
      if params[:week].nil?
        raise 'Please select a week before trying to process Turn and Transfer Actions.'
      else
        raise 'Turn actions for that week have already been processed.'
      end
    end
  end

  def end_of_turn(params)
    return unless params[:week].present? && Processing.find_by(message: "#{params[:week]}ET").nil?

    CreateLeagueTablesJob.perform_later(params[:week])
    PlayerUpdatesJob.perform_later(params[:week])
    UpgradeAdminJob.perform_later(params[:week])
    ClubUpdatesJob.perform_later(params[:week])

    Processing.create(message: "#{params[:week]}ET")
  end

  def process_player_updates(params)
    if params.present? && Processing.find_by(message: "#{params}PU").nil? # TODO: refactor
      Turn::PlayerUpdates.new(params).call
      Processing.create(message: "#{params}PU")
    else
      if params.nil?
        raise 'Please select a week before trying to process Player Updates.'
      else
        raise 'Player Updates for that week have already been processed.'
      end
    end
  end

  def process_upgrade_admin(params)
    if params.present? && Processing.find_by(message: "#{params}UA").nil?
      Turn::UpgradeAdmin.new(params).call
      Processing.create(message: "#{params}UA")
    else
      if params.nil?
        raise 'Please select a week before trying to process Upgrade Admin.'
      else
        raise 'Upgrade Admin for that week has already been processed.'
      end
    end
  end

  def process_club_updates(params)
    if params.present? && Processing.find_by(message: "#{params}CU").nil?
      Turn::ClubUpdates.new(params).call
      Processing.create(message: "#{params}CU")
    else
      if params.nil?
        raise 'Please select a week before trying to process Upgrade Admin.'
      else
        raise 'Club Updates for that week has already been processed.'
      end
    end
  end

  def process_article_updates(params)
    if params.present? && Processing.find_by(message: "#{params}AU").nil?
      Turn::ArticleUpdates.new(params).call
      Processing.create(message: "#{params}AU")
    else
      if params.nil?
        raise 'Please select a week before trying to process Upgrade Admin.'
      else
        raise 'Article Admin for that week has already been processed.'
      end
    end
  end
end
