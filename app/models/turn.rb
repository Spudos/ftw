class Turn < ApplicationRecord
  def process_turn_actions(params)
    stadium_upgrade(params[:week])
    property_upgrade(params[:week])
    player_upgrade(params[:week])
    coach_upgrade(params[:week])
    increment_upgrades
    fitness_increase
  end

  private

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
    existing_upgrade = Upgrade.find_by(action_id:)
    if existing_upgrade.nil?
      upgrade = Upgrade.create(action_id:, week:, club:, var1: stand, var2: seats.to_i, var3: 0)
      if upgrade.save
        puts "Upgrade saved successfully!"
      else
        puts "Error saving upgrade: #{upgrade.errors.full_messages.join(', ')}"
      end
    end
  end

  def property_upgrade(week)
    turns = Turn.where("var1 LIKE ?", 'property').where(week: week)
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
    existing_upgrade = Upgrade.find_by(action_id:)

    if existing_upgrade.nil?
    Upgrade.create(action_id:, week:, club:, var1: prop, var3: 0)
    end
  end

  def coach_upgrade(week)
    turns = Turn.where("var1 LIKE ?", 'coach%').where(week: week)
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
      add_to_coach_upgrades(value[:action_id], value[:week], value[:club], value[:var2])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def add_to_coach_upgrades(action_id, week, club, coach)
    existing_upgrade = Upgrade.find_by(action_id:)

    if existing_upgrade.nil?
    Upgrade.create(action_id:, week:, club:, var1: coach, var3: 0)
    end
  end

  def player_upgrade(week)
    turns = Turn.where("var1 LIKE ?", 'train%').where(week: week)
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
      train_player(value[:action_id], value[:week], value[:club], value[:var2], value[:var3])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def train_player(action_id, week, club, player, skill)
    existing_training = Message.find_by(action_id: action_id)

    if existing_training.nil?
      club_staff = Club.find_by(abbreviation: club)
      player_data = Player.find_by(club: club, name: player)
      coach = club_staff.send("staff_#{player_data.position}")

      if player_data[skill] < player_data.send("potential_#{skill}")
        if player_data[skill] < coach
          player_data[skill] += 1
          player_data.update(skill => player_data[skill])
          Message.create(action_id:, week:, club:, var1: "Training #{player} in #{skill} suceeded! His new value is #{player_data[skill]}")
        else
          Message.create(action_id:, week:, club:, var1: "Training #{player} in #{skill} failed - this coach isn't good enough to train #{skill} for #{player}")  
        end
      else
        Message.create(action_id:, week:, club:, var1: "Training #{player} in #{skill} failed due to reaching potential")
      end
    end
  end

  def bank_adjustment(action_id, week, club, reason, dept, amount)
    existing_message = Message.find_by(action_id: action_id)

    if existing_message.nil?
      club_full = Club.find_by(abbreviation: club)

      new_bal = club_full.bank_bal.to_i - amount.to_i
      club_full.update(bank_bal: new_bal)
      if reason == "coach"
        Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}")
      elsif reason == "property"
        Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}")
      elsif reason.end_with?("condition")
        Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{reason}")
      else
        Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{club_full[reason.gsub("capacity", "name")]}")
      end
    end
  end

  def increment_upgrades
    to_complete = Upgrade.all

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

    if item.var1.start_with?("staff")
      new_coach = club_full[item.var1] += 1
      club_full.update(item.var1 => new_coach)

      Message.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{item.var1} was completed, the new value is #{club_full[item.var1]}")

    elsif item.var1 == "facilities" || item.var1 == "hospitality" || item.var1 == "pitch"
      new_coach = club_full[item.var1] += 1
      club_full.update(item.var1 => new_coach)
    
      Message.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{item.var1} was completed, the new value is #{club_full[item.var1]}")
    
    elsif item.var1.ends_with?("condition")
      new_coach = club_full[item.var1] += 1
      club_full.update(item.var1 => new_coach)
  
      Message.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{item.var1} was completed, the new value is #{club_full[item.var1]}")

    else
      new_cap = club_full[item.var1] + item.var2.to_i
      club_full.update(item.var1 => new_cap)

      Message.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{club_full[item.var1.gsub("capacity", "name")]} was completed, the new value is #{club_full[item.var1]}")
    end
  end
end

def fitness_increase
  players = Player.all

  players.each do |player|
    if player.fitness < 100
      player.fitness += rand(0..5)
      player.fitness = 100 if player.fitness > 100
      player.save
    end
  end
end
