module TurnsStadiumHelper
  def stadium_upgrade(week)
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
      if value[:var2] == nil
        cost = value[:var3]
      else
        cost = value[:var2].to_i * 1000
      end
      
      bank_adjustment(value[:action_id], value[:week], value[:club], value[:var1], value[:var2], cost)
      add_to_stadium_upgrades(value[:action_id], value[:week], value[:club], value[:var1], value[:var2])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def add_to_stadium_upgrades(action_id, week, club, stand, seats)
    existing_upgrade = Upgrades.find_by(action_id:)
    if existing_upgrade.nil?
      upgrade = Upgrades.create(action_id:, week:, club:, var1: stand, var2: seats.to_i, var3: 0)
      if upgrade.save
        puts "Upgrade saved successfully!"
      else
        puts "Error saving upgrade: #{upgrade.errors.full_messages.join(', ')}"
      end
    end
  end

  def property_upgrade(week)
    turns = Turn.where("var1 LIKE ?", 'prop%').where(week: week)
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
      bank_adjustment(value[:action_id], value[:week], value[:club], value[:var1], value[:var2], value[:var3])
      add_to_property_upgrades(value[:action_id], value[:week], value[:club], value[:var2])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def add_to_property_upgrades(action_id, week, club, prop)
    existing_upgrade = Upgrades.find_by(action_id:)

    if existing_upgrade.nil?
    Upgrades.create(action_id:, week:, club:, var1: prop, var3: 0)
    end
  end

end

