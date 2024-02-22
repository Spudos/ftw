class Turn::TransferUpdates
  attr_reader :week

  Rails.cache.clear

  def initialize(week)
    @week = week
  end

  def call
    listed_player_bids
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
end
