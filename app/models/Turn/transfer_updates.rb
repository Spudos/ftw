class Turn::TransferUpdates
  attr_reader :week

  Rails.cache.clear

  def initialize(week)
    @week = week
  end

  def call
    listed_player_bids
    complete_deals
  end

  private

  def listed_player_bids
    bids = Transfer.where(status: "bid").group_by { |record| record.player_id }.map do |group, records|
      sorted_records = records.sort_by { |record| -record.bid }
      { group: group, records: sorted_records.map { |record| { player_id: record.player_id, sell_club: record.sell_club, buy_club: record.buy_club, week: record.week, bid: record.bid } } }
    end

    bids.each do |bid|
      bid[:records].each_with_index do |record, index|
        player = Player.find_by(id: record[:player_id])
        action_id = record[:week].to_s + record[:sell_club].to_s + record[:buy_club].to_s

        if index.zero?
          player.club_id = record[:buy_club]
          player.listed = false
          player.contract = 24
          player.save

          Message.create(action_id:, week: record[:week], club_id: record[:buy_club], var1: "Your #{record[:bid]} bid for #{player.name} suceeded!  The player has joined your club")

          Turn::BankAdjustment.new(action_id, record[:week], record[:sell_club].to_i, 'listed_sale', player.name, record[:bid] * -1).call
          Turn::BankAdjustment.new(action_id, record[:week], record[:buy_club].to_i, 'listed_purchase', player.name, record[:bid]).call

          Transfer.find_by(player_id: record[:player_id], buy_club: record[:buy_club]).update(status: 'transfer_completed')
        else
          Message.create(action_id:, week: record[:week], club_id: record[:buy_club], var1: "Your #{record[:bid]} bid for #{player.name} failed due to being outbid by another club")
          Transfer.find_by(player_id: record[:player_id], buy_club: record[:buy_club]).update(status: 'bid_failed')
        end
      end
    end
  end

  def complete_deals
    deals = Transfer.where(status: "deal").group_by { |record| record.player_id }.map do |group, records|
      {
        group:,
        records: records.map { |record| { player_id: record.player_id, sell_club: record.sell_club, buy_club: record.buy_club, week: record.week, bid: record.bid } } 
      }
    end

    deals.each do |deal|
      if deal[:records][0] == deal[:records][1]
        agreed_deal(deal)
      else
        failed_deal(deal)
      end
    end
  end

  def agreed_deal(deal)
    player_id = deal[:records][0][:player_id]
    sell_club_id = deal[:records][0][:sell_club]
    buy_club_id = deal[:records][0][:buy_club]
    bid = deal[:records][0][:bid]
    week = deal[:records][0][:week]
    player = Player.find_by(id: player_id)
    buy_club = Club.find_by(id: buy_club_id)
    sell_club = Club.find_by(id: sell_club_id)
    action_id = week.to_s + sell_club_id.to_s + buy_club_id.to_s

    if player.club_id == sell_club_id
      if player.value < bid
        player.club_id = buy_club_id
        player.contract = 24
        player.save

        Turn::BankAdjustment.new(action_id, week, sell_club_id.to_i, 'deal_sale', player.name, bid * -1).call
        Turn::BankAdjustment.new(action_id, week, buy_club_id.to_i, 'deal_purchase', player.name, bid).call

        Message.create(action_id:, week:, club_id: buy_club_id, var1: "Your deal to buy #{player.name} from #{sell_club.name} was completed successfully")
        Message.create(action_id:, week:, club_id: sell_club_id, var1: "Your deal to sell #{player.name} to #{buy_club.name} was completed successfully")
        Transfer.where(player_id:, buy_club:, sell_club:, week:).update(status: 'deal_completed')
      else
        Message.create(action_id:, week:, club_id: buy_club, var1: "Your deal to buy #{player.name} from #{sell_club.name} failed as the the player value is higher than the agreed amount")
        Message.create(action_id:, week:, club_id: sell_club, var1: "Your deal to sell #{player.name} to #{buy_club.name} failed as the the player value is higher than the agreed amount")
        Transfer.where(player_id:, buy_club:, sell_club:, week:).update(status: 'deal_failed')
      end
    else
      Message.create(action_id:, week:, club_id: buy_club, var1: "Your deal to buy #{player.name} from #{sell_club.name} failed as the the player is not owned by the selling club")
      Message.create(action_id:, week:, club_id: sell_club, var1: "Your deal to sell #{player.name} to #{buy_club.name} failed as the the player is not owned by your club")
      Transfer.where(player_id:, buy_club:, sell_club:, week:).update(status: 'deal_failed')
    end
  end

  def failed_deal(deal)
    player_id = deal[:records][0][:player_id]
    sell_club = deal[:records][0][:sell_club]
    buy_club = deal[:records][0][:buy_club]
    week = deal[:records][0][:week]
    player_name = Player.find_by(id: player_id)&.name
    buy_club_name = Club.find_by(id: buy_club)&.name
    sell_club_name = Club.find_by(id: sell_club)&.name
    action_id = week.to_s + sell_club.to_s + buy_club.to_s

    Message.create(action_id:, week:, club_id: buy_club, var1: "Your deal to buy #{player_name} from #{sell_club_name} failed as the details provided by both clubs did not agree")
    Message.create(action_id:, week:, club_id: sell_club, var1: "Your deal to sell #{player_name} to #{buy_club_name} failed as the details provided by both clubs did not agree")
    Transfer.where(player_id:, buy_club:, sell_club:, week:).update(status: 'deal_failed')
  end
end
