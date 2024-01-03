module TurnsHelper
  def bank_adjustment(action_id, week, club, reason, dept, amount)
    existing_message = Messages.find_by(action_id: action_id)

    if existing_message.nil?
      club_full = Club.find_by(abbreviation: club)

      new_bal = club_full.bank_bal.to_i - amount.to_i
      club_full.update(bank_bal: new_bal)
      if reason == "coach"
        Messages.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to the #{dept} department")
      else
        Messages.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to the #{club_full[reason.gsub("capacity", "name")]}")
      end
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

  def perform_completed_upgrades(item)
    club_full = Club.find_by(abbreviation: item.club)

    if item.var1 == 'coach'
      new_coach = club_full[item.var2] += 1
      club_full.update(item.var2 => new_coach)

      Messages.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{item.var2} was completed, the new value is #{club_full[item.var2]}")
    else
      new_cap = club_full[item.var1] + item.var2.to_i
      club_full.update(item.var1 => new_cap)

      Messages.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{club_full[item.var1.gsub("capacity", "name")]} was completed, the new value is #{club_full[item.var1]}")
    end
  end
end
