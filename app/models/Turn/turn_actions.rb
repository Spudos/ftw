class Turn::TurnActions
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def call
    player_upgrade
    fitness_upgrade
    unmanaged_bid
    circuit_sale
    stadium_upgrade
    property_upgrade
    coach_upgrade
    contract_renewal
    loyalty_increase
  end

  private

  def player_upgrade
    hash = {}

    Turn.where('var1 LIKE ?', 'train%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      train_player(value[:action_id], value[:week], value[:club_id].to_i, value[:var2], value[:var3])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def train_player(action_id, week, club_id, player, skill)
    if Message.find_by(action_id:).nil?
      club_staff = Club.find_by(id: club_id)
      player_data = Player.find_by(name: player)
      coach = club_staff.send("staff_#{player_data.position}")

      if player_data[skill] < player_data.send("potential_#{skill}")
        if player_data[skill] < coach
          player_data[skill] += 1
          player_data.update(skill => player_data[skill])
          Message.create(action_id:, week:, club_id:, var1: "Training #{player} in #{skill} suceeded! His new value is #{player_data[skill]}")
        else
          Message.create(action_id:, week:, club_id:, var1: "Training #{player} in #{skill} failed - this coach isn't good enough to train #{skill} for #{player}")  
        end
      else
        Message.create(action_id:, week:, club_id:, var1: "Training #{player} in #{skill} failed due to reaching potential")
      end
    end
  end

  def fitness_upgrade
    hash = {}

    Turn.where('var1 LIKE ?', 'fitness%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      player_fitness(value[:action_id], value[:week], value[:club_id].to_i, value[:var2])
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def player_fitness(action_id, week, club_id, player)
    if Message.find_by(action_id:).nil?
      player_data = Player.find_by(name: player)
      coach = Club.find_by(id: club_id)&.staff_fitness

      increased_fitness = player_data.fitness + coach
      final_fitness = increased_fitness > 100 ? 100 : increased_fitness

      player_data.update(fitness: final_fitness)

      Message.create(action_id:, week:, club_id:, var1: "Fitness training for #{player} was completed! His new value is #{final_fitness}")
    end
  end

  def unmanaged_bid
    hash = {}

    Turn.where('var1 LIKE ?', 'unmanaged%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, # unmanaged_bid
        var2: turn.var2, # player_id
        var3: turn.var3, # bid
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?

        player = Player.find_by(id: value[:var2].to_i)
        club = Club.find_by(id: value[:club_id].to_i)
        player_original_club = player.club

        if player_original_club.managed?
          Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "Your #{value[:var3]} bid for #{player.name} failed due to the player being at a managed club")
          transfer_save(value[:week], club.id, player_original_club[:id], value[:var2], value[:var3], 'player_managed')

        elsif bid_decision(value, player)
          if rand(100) > player.loyalty
            player.club = Club.find_by(id: value[:club_id].to_i)
            player[:contract] = 37
            player.save

            Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "Your bid for #{player.name} succeeded!  The player has joined your club for #{value[:var3]}")
            bank_adjustment(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], player.name, value[:var3])
            transfer_save(value[:week], club.id, player_original_club[:id], value[:var2], value[:var3], 'transfer_completed')

          else
            Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "Your #{value[:var3]} bid for #{player.name} failed due to the player choosing not to join your club")
            transfer_save(value[:week], club.id, player_original_club[:id], value[:var2], value[:var3], 'player_refusal')
          end

        else
          Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "Your #{value[:var3]} bid for #{player.name} failed due to not meet an acceptable valuation for the player")
          transfer_save(value[:week], club.id, player_original_club[:id], value[:var2], value[:var3], 'club_refusal')
        end
      end
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def bid_decision(value, player)
    if player.total_skill < 77
      value[:var3].to_i > player.value * 1
    elsif player.total_skill < 99
      value[:var3].to_i > player.value * 1.234
    elsif player.total_skill < 110
      value[:var3].to_i > player.value * 1.498
    else
      value[:var3].to_i > player.value * 1.723
    end
  end

  def circuit_sale
    hash = {}

    Turn.where('var1 LIKE ?', 'circuit%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, # circuit
        var2: turn.var2, # player_id
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?
        player = Player.find_by(id: value[:var2].to_i)
        club = Club.find_by(id: value[:club_id].to_i)

        if player.club.id == value[:club_id].to_i
          proceeds = (player.value * -0.75).to_i
          proceeds_positive = (proceeds * -1).to_i

          player[:club_id] = 42
          player.save

          Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "#{player.name} was sold to the free agent circuit for #{proceeds_positive}")
          bank_adjustment(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], player.name, proceeds)
          transfer_save(value[:week], 42, club.id, value[:var2], proceeds, 'sale_completed')
        else
          Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "#{player.name} could not be sold to the free agent circuit due to not being at your club")
          transfer_save(value[:week], 42, player.club_id, value[:var2], proceeds, 'sale_failed')
        end
      end

      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def transfer_save(week, buy_club, sell_club, player_id, bid, status)
    Transfer.create(week:, buy_club:, sell_club:, player_id:, bid:, status:)
  end

  def stadium_upgrade
    hash = {}

    Turn.where('var1 LIKE ?', 'stand%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?
        if value[:var2] == nil
          cost = value[:var3]
        else
          cost = value[:var2].to_i * 1000
        end

        bank_adjustment(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], value[:var2], cost)
        add_to_stadium_upgrades(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], value[:var2])
        turn = Turn.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def add_to_stadium_upgrades(action_id, week, club_id, stand, seats)
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club_id:, var1: stand, var2: seats.to_i, var3: 0)
    end
  end

  def property_upgrade
    turns = Turn.where('var1 LIKE ?', 'property').where(week:)
    hash = {}

    turns.each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?
        bank_adjustment(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], value[:var2], value[:var3])
        add_to_property_upgrades(value[:action_id], value[:week], value[:club_id].to_i, value[:var2])
        turn = Turn.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def add_to_property_upgrades(action_id, week, club_id, prop)
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club_id:, var1: prop, var3: 0)
    end
  end

  def coach_upgrade
    hash = {}

    Turn.where('var1 LIKE ?', 'coach%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?
        bank_adjustment(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], value[:var2], value[:var3])
        add_to_coach_upgrades(value[:action_id], value[:week], value[:club_id].to_i, value[:var2])
        turn = Turn.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def add_to_coach_upgrades(action_id, week, club_id, coach)
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club_id:, var1: coach, var3: 0)
    end
  end

  def contract_renewal
    hash = {}

    Turn.where('var1 LIKE ?', 'contract%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, #contract
        var2: turn.var2, #player_id
        var3: turn.var3, #amount
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?

        player = Player.find_by(id: value[:var2].to_i)

        if rand(0..100) < (80 - (player.loyalty - (value[:var3].to_i / 100000)))
          player.contract = 24
          player.save

          bank_adjustment(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], player.name, value[:var3])
        else
          if player.loyalty > 5
            player.loyalty -= 5
            player.save
          end

          Message.create(action_id: value[:action_id], week: value[:week], club_id: value[:club_id].to_i, var1: "Your contract renewal for #{player.name} failed due to the player choosing not to renew")
        end

        turn = Turn.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def loyalty_increase
    hash = {}

    Turn.where('var1 LIKE ?', 'loyalty%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, #loyalty
        var2: turn.var2, #player_id
        var3: turn.var3, #amount
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?

        player = Player.find_by(id: value[:var2].to_i)

        player.loyalty += (value[:var3].to_i / 100000).to_i
        player.save

        bank_adjustment(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], player.name, value[:var3])

        turn = Turn.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def bank_adjustment(action_id, week, club_id, reason, dept, amount)
    club_full = Club.find_by(id: club_id)

    new_bal = club_full.bank_bal.to_i - amount.to_i
    club_full.update(bank_bal: new_bal)
    if reason == 'coach'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}")
    elsif reason == 'property'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}")
    elsif reason == 'unmanaged_bid'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due a player purchase (#{dept})")
    elsif reason == 'circuit'
      amount_positive = (amount * -1).to_i
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was creditied with #{amount_positive} due a player sale (#{dept})")
    elsif reason.end_with?('condition')
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{reason}")
    elsif reason == 'contract'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to a 24 week contract renewal for #{dept}")
    elsif reason == 'loyalty'
      Message.create(action_id:, week:, club_id:, var1: "You paid an amount to #{dept} to thank him for his contribution to the club.  He now feels more loyal and is more likely to stick with the team in difficult times.  You bank was charged with #{amount}")
    else
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{club_full[reason.gsub("capacity", "name")]}")
    end
  end
end
