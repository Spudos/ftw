class Club::UpgradeAdmin
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def call
    Upgrade.all.each do |item|
      item.var3 += 1
      item.save

      if item.var3 == 6
        perform_completed_upgrades(item, week)
      end
    end
  end

  private

  def perform_completed_upgrades(item, week)
    club_full = Club.find_by(id: item.club_id)
    if item.var1.start_with?('staff')
      new_coach = club_full[item.var1] += 1
      club_full.update(item.var1 => new_coach)

      Message.create(action_id: item.action_id, week: week, club_id: item.club_id,
                     var1: "Your upgrade to the #{item.var1} was completed, the new value is #{club_full[item.var1]}")

    elsif item.var1 == 'facilities' || item.var1 == 'hospitality' || item.var1 == 'pitch'
      new_coach = club_full[item.var1] += 1
      club_full.update(item.var1 => new_coach)

      Message.create(action_id: item.action_id, week:, club_id: item.club_id,
                     var1: "Your upgrade to the #{item.var1} was completed, the new value is #{club_full[item.var1]}")

    elsif item.var1.ends_with?('condition')
      new_coach = club_full[item.var1] += 1
      club_full.update(item.var1 => new_coach)

      Message.create(action_id: item.action_id, week:, club_id: item.club_id,
                     var1: "Your upgrade to the #{item.var1} was completed, the new value is #{club_full[item.var1]}")

    else
      new_cap = club_full[item.var1] + item.var2.to_i
      club_full.update(item.var1 => new_cap)

      Message.create(action_id: item.action_id, week:, club_id: item.club_id,
                     var1: "Your upgrade to the #{club_full[item.var1.gsub("capacity", "name")]} was completed, the new value is #{club_full[item.var1]}")
    end
  end
end
