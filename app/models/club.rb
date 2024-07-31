class Club < ApplicationRecord
  has_many :players

  def submission(params)
    club = Club.where(managed: false, league: params[:club][:league])&.first

    Club::ClubCreation.new(club, params).call
  end

  def process_upgrade_admin(params, turn)
    if params.present? && !turn.upgrade_admin
      Club::UpgradeAdmin.new(params).call
      turn.update(upgrade_admin: true)
    elsif params.nil?
      Error.create(error_type: 'club_update', message: 'Please select a week before trying to process Upgrade Admin.')
    else
      Error.create(error_type: 'club_update', message: 'Upgrade Admin for that week has already been processed.')
    end
  end

  def process_club_updates(params, turn)
    if params.present? && !turn.club_update
      Club::ClubUpdates.new(params).call
      turn.update(club_update: true)
    elsif params.nil?
      Error.create(error_type: 'club_update', message: 'Please select a week before trying to process Upgrade Admin.')
    else
      Error.create(error_type: 'club_update', message: 'Club Updates for that week has already been processed.')
    end
  end

  def process_squad_corrections(turn)
    if !turn.squad_correction
      Club::SquadCorrections.new.call
      turn.update(squad_correction: true)
    else
      Error.create(error_type: 'club_update', message: 'Squad Corrections for that week has already been processed.')
    end
  end

  def finance_items(club)
    highest_week_number = Message.maximum(:week)
    messages = Message.where(club_id: club, week: highest_week_number)

    total_income = 0
    total_expenditure = 0

    messages.each do |message|
      if message.var2.present? && message.var2.start_with?('inc')
        total_income += message.var3
      elsif message.var2.present? && message.var2.start_with?('dec')
        total_expenditure += message.var3
      end
    end

    items = {
      transfers_out: messages.where(var2: 'inc-transfers_out').sum(:var3),
      tv_income: messages.where(var2: 'inc-tv_income').sum(:var3),
      club_shop_online: messages.where(var2: 'inc-club_shop_online').sum(:var3),
      club_shop_match: messages.where(var2: 'inc-club_shop_match').sum(:var3),
      gate_receipts: messages.where(var2: 'inc-gate_receipts').sum(:var3),
      hospitality: messages.where(var2: 'inc-hospitality').sum(:var3),
      facilities: messages.where(var2: 'inc-facilities').sum(:var3),
      programs: messages.where(var2: 'inc-programs').sum(:var3),
      other: messages.where(var2: 'inc-other').sum(:var3),
      player_wages: messages.where(var2: 'dec-player_wages').sum(:var3),
      staff_wages: messages.where(var2: 'dec-staff_wages').sum(:var3),
      transfers_in: messages.where(var2: 'dec-transfers_in').sum(:var3),
      stadium_upkeep: messages.where(var2: 'dec-stadium_upkeep').sum(:var3),
      policing: messages.where(var2: 'dec-policing').sum(:var3),
      stewards: messages.where(var2: 'dec-stewards').sum(:var3),
      medical: messages.where(var2: 'dec-medical').sum(:var3),
      bonuses: messages.where(var2: 'dec-bonuses').sum(:var3),
      contracts: messages.where(var2: 'dec-contracts').sum(:var3),
      upgrades: messages.where(var2: 'dec-upgrades').sum(:var3),
      total_income:,
      total_expenditure:,
      week: highest_week_number
    }
    return items
  end
end
