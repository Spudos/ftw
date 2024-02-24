class Turn::TransferActions
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def call
    list_player
    unlist_player
    unmanaged_bid
    circuit_sale
    deal
    listed_bid
  end

  private

  def list_player
    hash = {}

    Turn.where('var1 LIKE ?', 'list').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, # list
        var2: turn.var2, # player_id
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      player = Player.find_by(id: value[:var2])
      if player.club_id == value[:club_id].to_i
        player.listed = true
        player.save
        Message.create(action_id: value[:action_id], week: value[:week], club_id: value[:club_id], var1: "Your player, #{player.name}, was put on the transfer list")

        turn = Turn.find(key)
        turn.update(date_completed: DateTime.now)
      else
        Message.create(action_id: value[:action_id], week: value[:week], club_id: value[:club_id], var1: "Player #{player.name} could not be listed due to not being at your club")
      end
    end
  end

  def unlist_player
    hash = {}
    Turn.where('var1 LIKE ?', 'unlist').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, # unlist
        var2: turn.var2, # player_id
        var3: turn.var3,
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      player = Player.find_by(id: value[:var2])
      if player.club_id == value[:club_id].to_i && player.listed != false
        player.listed = false
        player.loyalty = 5
        player.save
        Message.create(action_id: value[:action_id], week: value[:week], club_id: value[:club_id], var1: "Your player, #{player.name}, was removed from the transfer list.  However, he is unhappy with the way he has been treated by you")
      elsif player.listed == false
        Message.create(action_id: value[:action_id], week: value[:week], club_id: value[:club_id], var1: "Player #{player.name} could not be unlisted as he is not listed at present")
      else
        Message.create(action_id: value[:action_id], week: value[:week], club_id: value[:club_id], var1: "Player #{player.name} could not be unlisted due to not being at your club")
      end
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
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
          if rand(0..100) > player.loyalty
            player.club = Club.find_by(id: value[:club_id].to_i)
            player[:contract] = 24
            player.save

            Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "Your bid for #{player.name} succeeded!  The player has joined your club for #{value[:var3]}")
            Turn::BankAdjustment.new(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], player.name, value[:var3]).call
            transfer_save(value[:week], club.id, player_original_club[:id], value[:var2], value[:var3], 'completed')

            player_original_club.bank_bal += value[:var3].to_i
            player_original_club.save
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

          player[:club_id] = 242
          player.save

          Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "#{player.name} was sold to the free agent circuit for #{proceeds_positive}")
          Turn::BankAdjustment.new(value[:action_id], value[:week], value[:club_id].to_i, value[:var1], player.name, proceeds).call
          transfer_save(value[:week], 242, club.id, value[:var2], proceeds, 'completed')
        else
          Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "#{player.name} could not be sold to the free agent circuit due to not being at your club")
          transfer_save(value[:week], 242, player.club_id, value[:var2], proceeds, 'sale_failed')
        end
      end

      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def deal
    hash = {}
    Turn.where('var1 LIKE ?', 'deal').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, # deal
        var2: turn.var2, # player_id
        var3: turn.var3, # amount
        var4: turn.var4, # other club
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      player = Player.find_by(id: value[:var2].to_i)

      if player.club_id == value[:club_id].to_i
        transfer_save(value[:week], value[:var4], value[:club_id], value[:var2], value[:var3], 'deal')
      else
        transfer_save(value[:week], value[:club_id], value[:var4], value[:var2], value[:var3], 'deal')
      end
      turn = Turn.find(key)
      turn.update(date_completed: DateTime.now)
    end
  end

  def listed_bid
    hash = {}

    Turn.where('var1 LIKE ?', 'listed_bid').where(week:).each do |turn|
      hash[turn.id] = {
        action_id: turn.week.to_s + turn.club_id + turn.id.to_s,
        week: turn.week,
        club_id: turn.club_id,
        var1: turn.var1, # listed_bid
        var2: turn.var2, # player_id
        var3: turn.var3, # amount bid
        date_completed: turn.date_completed
      }
    end

    hash.each do |key, value|
      if Message.find_by(action_id: value[:action_id]).nil?

        player = Player.find_by(id: value[:var2].to_i)
        club = Club.find_by(id: value[:club_id].to_i)

        if player.listed == true
          if value[:var3].to_i > player.value
          Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "Your bid of #{player.name} for #{player.name} was logged")
          transfer_save(value[:week], value[:club_id], player.club_id, value[:var2], value[:var3], 'bid')
          else
            Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "Your bid for #{player.name} failed due to not meeting an acceptable valuation for the player")
            transfer_save(value[:week], value[:club_id], player.club_id, value[:var2], value[:var3], 'bid_failed')
          end
        else
          Message.create(action_id: value[:action_id], week: value[:week], club_id: club.id, var1: "You cannot bid for #{player.name} as he is not listed for sale")
          transfer_save(value[:week], value[:club_id], player.club_id, value[:var2], value[:var3], 'bid_failed')
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
