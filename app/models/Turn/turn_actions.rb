class Turn::TurnActions
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def call
    unmanaged_bid
    circuit_sale
    stadium_upgrade
    property_upgrade
    coach_upgrade
  end

  def unmanaged_bid
    hash = {}

    Turn.where('var1 LIKE ?', 'unmanaged%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club: turn.club_id_id,
        var1: turn.var1, # unmanaged_bid
        var2: turn.var2, # player_id
        var3: turn.var3, # bid
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?

        player = Player.find_by(id: value[:var2].to_i)
        club = Club.find_by(id: value[:club])
        player_original_club = player.club

        if player_original_club.managed?
          Message.create(action_id: value[:action_id], week: value[:week], club: club.club_id, var1: "Your #{value[:var3]} bid for #{player.name} failed due to the player being at a managed club")
          transfer_save(value[:week], club.id, player_original_club[:id], value[:var2], value[:var3], 'player_managed')

        elsif bid_decision(value, player)
          if rand(100) > player.loyalty
            player.club = Club.find_by(id: value[:club])
            player[:contract] = 37
            player.save

            Message.create(action_id: value[:action_id], week: value[:week], club: club.club_id, var1: "Your bid for #{player.name} succeeded!  The player has joined your club for #{value[:var3]}")
            bank_adjustment(value[:action_id], value[:week], value[:club], value[:var1], player.name, value[:var3])
            transfer_save(value[:week], club.id, player_original_club[:id], value[:var2], value[:var3], 'transfer_completed')

          else
            Message.create(action_id: value[:action_id], week: value[:week], club: club.club_id, var1: "Your #{value[:var3]} bid for #{player.name} failed due to the player choosing not to join your club")
            transfer_save(value[:week], club.id, player_original_club[:id], value[:var2], value[:var3], 'player_refusal')
          end

        else
          Message.create(action_id: value[:action_id], week: value[:week], club: club.club_id, var1: "Your #{value[:var3]} bid for #{player.name} failed due to not meet an acceptable valuation for the player")
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
        club: turn.club_id,
        var1: turn.var1, # circuit
        var2: turn.var2, # player_id
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?
        player = Player.find_by(id: value[:var2].to_i)
        club = Club.find_by(id: value[:club])

        if player.club.club_id == value[:club]
          proceeds = (player.value * -0.75).to_i
          proceeds_positive = (proceeds * -1).to_i

          player[:club_id] = 42
          player[:club] = 'xxx'
          player.save

          Message.create(action_id: value[:action_id], week: value[:week], club: club.club_id, var1: "#{player.name} was sold to the free agent circuit for #{proceeds_positive}")
          bank_adjustment(value[:action_id], value[:week], value[:club], value[:var1], player.name, proceeds)
          transfer_save(value[:week], 42, club.id, value[:var2], proceeds, 'sale_completed')
        else
          Message.create(action_id: value[:action_id], week: value[:week], club: club.club_id, var1: "#{player.name} could not be sold to the free agent circuit due to not being at your club")
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
        club: turn.club_id,
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

        bank_adjustment(value[:action_id], value[:week], value[:club], value[:var1], value[:var2], cost)
        add_to_stadium_upgrades(value[:action_id], value[:week], value[:club], value[:var1], value[:var2])
        turn = Turn.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def add_to_stadium_upgrades(action_id, week, club, stand, seats)
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club:, var1: stand, var2: seats.to_i, var3: 0)
    end
  end

  def property_upgrade
    turns = Turn.where('var1 LIKE ?', 'property').where(week:)
    hash = {}

    turns.each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?
        bank_adjustment(value[:action_id], value[:week], value[:club], value[:var1], value[:var2], value[:var3])
        add_to_property_upgrades(value[:action_id], value[:week], value[:club], value[:var2])
        turn = Turn.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def add_to_property_upgrades(action_id, week, club, prop)
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club:, var1: prop, var3: 0)
    end
  end

  def coach_upgrade
    hash = {}

    Turn.where('var1 LIKE ?', 'coach%').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club: turn.club_id,
        var1: turn.var1,
        var2: turn.var2,
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?
        bank_adjustment(value[:action_id], value[:week], value[:club], value[:var1], value[:var2], value[:var3])
        add_to_coach_upgrades(value[:action_id], value[:week], value[:club], value[:var2])
        turn = Turn.find(key)
        turn.update(date_completed: DateTime.now)
      end
    end
  end

  def add_to_coach_upgrades(action_id, week, club, coach)
    if Upgrade.find_by(action_id:).nil?
      Upgrade.create(action_id:, week:, club:, var1: coach, var3: 0)
    end
  end

  def bank_adjustment(action_id, week, club, reason, dept, amount)
    club_full = Club.find_by(id: club)

    new_bal = club_full.bank_bal.to_i - amount.to_i
    club_full.update(bank_bal: new_bal)
    if reason == 'coach'
      Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}")
    elsif reason == 'property'
      Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}")
    elsif reason == 'unmanaged_bid'
      Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due a player purchase (#{dept})")
    elsif reason == 'circuit'
      amount_positive = (amount * -1).to_i
      Message.create(action_id:, week:, club:, var1: "Your bank account was creditied with #{amount_positive} due a player sale (#{dept})")
    elsif reason.end_with?('condition')
      Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{reason}")
    else
      Message.create(action_id:, week:, club:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{club_full[reason.gsub("capacity", "name")]}")
    end
  end
end
