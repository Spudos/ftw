module TurnsStadiumHelper
  def stadium_upgrades(week)
    turns = Turn.where("var1 LIKE ?", 'stand%').where(week: week)
    hash = {}

    turns.each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club + turn.id.to_s,
        week: turn.week,
        club: turn.club,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        Actioned: turn.date_completed
      }
  end

    hash.each do |key, value|
      bank_adjustment(value[:action_id], value[:week], value[:club], value[:var1], value[:var3])
      add_to_upgrades(value[:action_id], value[:week], value[:club], value[:var1], value[:var2])
    end
  end

  def add_to_upgrades(action_id, week, club, stand, seats)
    existing_upgrade = Upgrades.find_by(action_id:)

    if existing_upgrade.nil?
    Upgrades.create(action_id:, week:, club:, var1: stand, var2: seats, var3: 0)
    end
  end
end
