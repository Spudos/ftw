class Turn::Transfers
  attr_reader :week

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

        if player.club.club_id == value[:club_id].to_i
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
end
