class Turn < ApplicationRecord
  def process_turn_actions(params)
    unmanaged_bid(params[:week])
    stadium_upgrade(params[:week])
    property_upgrade(params[:week])
    player_upgrade(params[:week])
    fitness_upgrade(params[:week])
    coach_upgrade(params[:week])
    increment_upgrades
    fitness_increase
    contract_decrease
    player_value
    player_wages
  end

  private

  def unmanaged_bid(week)
    hash = {}

    Turn.where('var1 LIKE ?', 'unmanaged%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club + turn.id.to_s,
        week: turn.week,
        club: turn.club,
        var1: turn.var1, #unmanaged
        var2: turn.var2, #player_id
        var3: turn.var3, #bid
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      player = Player.find_by(id: value[:var2].to_i)
      if player.club.managed
        Message.create(action_id: value[:action_id], week: value[:week], club: value[:club], var1: "Your bid for #{player.name} failed due to the player being at a managed club")
      else
        if value[:var3].to_i > player.value * 1.5
          Message.create(action_id: value[:action_id], week: value[:week], club: value[:club], var1: "Your bid for #{player.name} succeeded!  The player has joined your club for #{value[:var3]}")
          player.club = value[:club]
          player.club_id = Club.find_by(abbreviation: value[:club]).id
          player.save
          bank_adjustment(value[:action_id], value[:week], value[:club], value[:var1], player.name, value[:var3])
        else
          Message.create(action_id: value[:action_id], week: value[:week], club: value[:club], var1: "Your bid for #{player.name} failed due to not meeting the clubs valuation for the player")
        end
      end

      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def stadium_upgrade(week)
    hash = {}

    Turn.where('var1 LIKE ?', 'stand%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club + turn.id.to_s,
        week: turn.week,
        club: turn.club,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
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
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club:, var1: stand, var2: seats.to_i, var3: 0)
    end
  end

  def property_upgrade(week)
    turns = Turn.where('var1 LIKE ?', 'property').where(week:)
    hash = {}

    turns.each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club + turn.id.to_s,
        week: turn.week,
        club: turn.club,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
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
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club:, var1: prop, var3: 0)
    end
  end

  def coach_upgrade(week)
    hash = {}

    Turn.where('var1 LIKE ?', 'coach%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club + turn.id.to_s,
        week: turn.week,
        club: turn.club,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
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
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club:, var1: coach, var3: 0)
    end
  end

  def player_upgrade(week)
    hash = {}

    Turn.where('var1 LIKE ?', 'train%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club + turn.id.to_s,
        week: turn.week,
        club: turn.club,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      train_player(value[:action_id], value[:week], value[:club], value[:var2], value[:var3])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def train_player(action_id, week, club, player, skill)
    if Message.find_by(action_id:).nil?
      club_staff = Club.find_by(abbreviation: club)
      player_data = Player.find_by(club:, name: player)
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

  def fitness_upgrade(week)
    hash = {}

    Turn.where('var1 LIKE ?', 'fitness%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club + turn.id.to_s,
        week: turn.week,
        club: turn.club,
        var1: turn.var1,
        var2: turn.var2,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      player_fitness(value[:action_id], value[:week], value[:club], value[:var2])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def player_fitness(action_id, week, club, player)
    if Message.find_by(action_id:).nil?
      player_data = Player.find_by(club:, name: player)
      coach = Club.find_by(abbreviation: club)&.staff_fitness

      increased_fitness = player_data.fitness + coach
      final_fitness = increased_fitness > 100 ? 100 : increased_fitness

      player_data.update(fitness: final_fitness)

      Message.create(action_id:, week:, club:, var1: "Fitness training for #{player} was completed! His new value is #{final_fitness}")
    end
  end

  def bank_adjustment(action_id, week, club, reason, dept, amount)
    if Message.find_by(action_id:).nil?
      club_full = Club.find_by(abbreviation: club)

      new_bal = club_full.bank_bal.to_i - amount.to_i
      club_full.update(bank_bal: new_bal)
      if reason == 'coach'
        Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}")
      elsif reason == 'property'
        Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}")
      elsif reason == 'unmanged_bid'
        Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due a player purchase (#{dept})")
      elsif reason.end_with?('condition')
        Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{reason}")
      else
        Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{club_full[reason.gsub("capacity", "name")]}")
      end
    end
  end

  def increment_upgrades
    Upgrade.all.each do |item|
      item.var3 += 1
      item.save

      if item.var3 == 6
        perform_completed_upgrades(item)
      end
    end
  end

  def perform_completed_upgrades(item)
    club_full = Club.find_by(abbreviation: item.club)

    if item.var1.start_with?('staff')
      new_coach = club_full[item.var1] += 1
      club_full.update(item.var1 => new_coach)

      Message.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{item.var1} was completed, the new value is #{club_full[item.var1]}")

    elsif item.var1 == 'facilities' || item.var1 == 'hospitality' || item.var1 == 'pitch'
      new_coach = club_full[item.var1] += 1
      club_full.update(item.var1 => new_coach)

      Message.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{item.var1} was completed, the new value is #{club_full[item.var1]}")

    elsif item.var1.ends_with?('condition')
      new_coach = club_full[item.var1] += 1
      club_full.update(item.var1 => new_coach)

      Message.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{item.var1} was completed, the new value is #{club_full[item.var1]}")

    else
      new_cap = club_full[item.var1] + item.var2.to_i
      club_full.update(item.var1 => new_cap)

      Message.create(action_id: item.action_id, week: item.week, club: item.club, var1: "Your upgrade to the #{club_full[item.var1.gsub("capacity", "name")]} was completed, the new value is #{club_full[item.var1]}")
    end
  end

  def fitness_increase
    player_data.each do |player|
      if player.fitness != 100
        player.fitness += rand(0..5)
        player.fitness = 100 if player.fitness > 100
        player.save
      end
    end
  end

  def contract_decrease
    player_data.each do |player|
      if player.contract.positive?
        player.contract -= 1
        player.contract = 0 if player.contract.negative?
        player.save
      else
        player.contract = 0
        player.save
      end
    end
  end

  def player_value
    player_data.each do |player|
      if player.total_skill < 77
        player.value = player.total_skill * 259740
      elsif player.total_skill < 99
        player.value = player.total_skill * 505050
      elsif player.total_skill < 110
        player.value = player.total_skill * 772727
      else
        player.value = player.total_skill * 867546
      end

      player.save
    end
  end

  def player_wages
    player_data.each do |player|
      if player.total_skill < 77
        player.wages = player.total_skill * 845
      elsif player.total_skill < 99
        player.wages = player.total_skill * 2025
      elsif player.total_skill < 110
        player.wages = player.total_skill * 3287
      else
        player.wages = player.total_skill * 4181
      end

      player.save
    end
  end

  def player_data
    @player_data ||= Player.includes(:performances, :goals, :assists, :club).load
  end
end

#------------------------------------------------------------------------------
# Turn
#
# Name           SQL Type             Null    Primary Default
# -------------- -------------------- ------- ------- ----------
# id             INTEGER              false   true              
# week           INTEGER              true    false             
# club           varchar              true    false             
# var1           varchar              true    false             
# var2           varchar              true    false             
# var3           varchar              true    false             
# created_at     datetime(6)          false   false             
# updated_at     datetime(6)          false   false             
# date_completed date                 true    false             
#
#------------------------------------------------------------------------------
