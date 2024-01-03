module TurnsHelper
  def perform_completed_upgrades(item)
    club_full = Club.find_by(abbreviation: item.club)
    
    new_cap = club_full[item.var1] + item.var2.to_i
    club_full.update(item.var1 => new_cap)

    Messages.create(action_id: item.action_id, week: item.week, club: item.club, var1: item.var1, var2: 'complete')
  end

  def bank_adjustment(action_id, week, club, reason, amount)
    existing_message = Messages.find_by(action_id: action_id)

    if existing_message.nil?
      club_full = Club.find_by(abbreviation: club)

      new_bal = club_full.bank_bal.to_i - amount.to_i
      club_full.update(bank_bal: new_bal)

      Messages.create(action_id:, week:, club:, var1: reason, var2: amount)
    end
  end

  def increment_upgrades
    to_complete = Upgrades.all

    to_complete.each do |item|
      item.var3 += 1
      item.save

      if item.var3 == 6
        perform_completed_upgrades(item)
      end
    end
  end
end
