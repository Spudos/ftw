require 'rails_helper'
require 'pry'

RSpec.describe Transfer, type: :model do
  describe 'call: unmanaged_bid' do
    it 'bid fails as the player belongs to a managed club' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'unmanaged_bid', var2: 1, var3: 1_000_001, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0, managed: true)
      create(:player, id: 1, club_id: 2, value: 1_000_000, loyalty: 10, total_skill: 76)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(15)

      Transfer::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(2)
      expect(Club.first.bank_bal).to eq(0)
      expect(Club.last.bank_bal).to eq(0)
    end

    it 'rand roll higher than loyalty and value higher than threshold so player moves to club 1 and deduct sale proceeds from buying club bank and add to selling club bank' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'unmanaged_bid', var2: 1, var3: 1_500_000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:player, id: 1, club_id: 2, value: 1_000_000, loyalty: 10)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(15)

      Transfer::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(1)
      expect(Player.first.tl).to eq(6)
      expect(Club.first.bank_bal).to eq(-1500000)
      expect(Club.last.bank_bal).to eq(1500000)
    end

    it 'rand roll higher than loyalty and bid lower than threshold so player and club details dont change' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'unmanaged_bid', var2: 1, var3: 500000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:player, id: 1, club_id: 2, value: 1000000, loyalty: 10)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(15)

      Transfer::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(2)
      expect(Club.first.bank_bal).to eq(0)
      expect(Club.last.bank_bal).to eq(0)
    end

    it 'rand roll lower than loyalty so player and club details dont change' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'unmanaged_bid', var2: 1, var3: 1500000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:player, id: 1, club_id: 2, value: 1000000, loyalty: 10)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(5)

      Transfer::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(2)
      expect(Club.first.bank_bal).to eq(0)
      expect(Club.last.bank_bal).to eq(0)
    end
  end

  describe 'call: circuit_sale' do
    it 'player has tl so no sale' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'circuit', var2: 1, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 242, bank_bal: 0)
      create(:player, id: 1, club_id: 1, value: 1_000_000, tl: 6)

      Transfer::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(1)
      expect(Player.first.tl).to eq(6)
      expect(Club.first.bank_bal).to eq(0)
    end

    it 'move the player to club 242 and adds 50% value as he is 85 rated to the selling club' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'circuit', var2: 1, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 242, bank_bal: 0)
      create(:player, id: 1, club_id: 1, value: 1_000_000)

      Transfer::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(242)
      expect(Player.first.tl).to eq(6)
      expect(Club.first.bank_bal).to eq(500_000)
    end

    it 'move the player to club 242 and adds 25% value as he is > 60 < 70 rated to the selling club' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'circuit', var2: 1, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 242, bank_bal: 0)
      create(:player, id: 1, club_id: 1, value: 1_000_000, total_skill: 65)

      Transfer::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(242)
      expect(Player.first.tl).to eq(6)
      expect(Club.first.bank_bal).to eq(250_000)
    end

    it 'move the player to club 242 and adds 0 value as he is < 61 rated to the selling club' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'circuit', var2: 1, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 242, bank_bal: 0)
      create(:player, id: 1, club_id: 1, value: 1_000_000, total_skill: 55)

      Transfer::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(242)
      expect(Player.first.tl).to eq(6)
      expect(Club.first.bank_bal).to eq(0)
    end

    it 'no change to player club or club funds as he doesnt belong to the selling club' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'circuit', var2: 1, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:player, id: 1, club_id: 2, value: 1_000_000)

      Transfer::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(2)
      expect(Club.first.bank_bal).to eq(0)
    end
  end

  describe 'call: list_player' do
    it 'player status change to listed:true' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'list', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1, listed: false)

      Transfer::TransferActions.new(week).call

      expect(Player.first.listed).to eq(true)
    end

    it 'no listed status change as player has tl' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'list', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, listed: false, tl: 6)

      Transfer::TransferActions.new(week).call

      expect(Player.first.listed).to eq(false)
    end

    it 'no listed status change if player is not owned by the club' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'list', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, listed: false)

      Transfer::TransferActions.new(week).call

      expect(Player.first.listed).to eq(false)
    end
  end

  describe 'call: unlist_player' do
    it 'player status change to listed:false and set loyalty to 5' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'unlist', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1, loyalty: 10, listed: true)

      Transfer::TransferActions.new(week).call

      expect(Player.first.listed).to eq(false)
      expect(Player.first.loyalty).to eq(5)
    end

    it 'no listed status change if player is not owned by the club' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'unlist', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, loyalty: 10, listed: true)

      Transfer::TransferActions.new(week).call

      expect(Player.first.listed).to eq(true)
      expect(Player.first.loyalty).to eq(10)
    end

    it 'no listed status change if player is not listed by the club' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'unlist', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1, loyalty: 10, listed: false)

      Transfer::TransferActions.new(week).call

      expect(Player.first.listed).to eq(false)
      expect(Player.first.loyalty).to eq(10)
    end
  end

  describe 'call: deal' do
    it 'deal details logged to be processed at end of turn' do
      week = 4
      create(:turn_actions, week: 4, club_id: 1, var1: 'deal', var2: 1, var3: 2_000_000, var4: 2, date_completed: nil)
      create(:turn_actions, week: 4, club_id: 2, var1: 'deal', var2: 1, var3: 2_000_000, var4: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1)

      Transfer::TransferActions.new(week).call

      expect(Transfer.first.player_id).to eq(1)
      expect(Transfer.first.sell_club).to eq(1)
      expect(Transfer.first.buy_club).to eq(2)
      expect(Transfer.first.week).to eq(4)
      expect(Transfer.first.bid).to eq(2_000_000)
      expect(Transfer.first.status).to eq('deal')

      expect(Transfer.last.player_id).to eq(1)
      expect(Transfer.last.sell_club).to eq(1)
      expect(Transfer.last.buy_club).to eq(2)
      expect(Transfer.last.week).to eq(4)
      expect(Transfer.last.bid).to eq(2_000_000)
      expect(Transfer.last.status).to eq('deal')
    end

    it 'deal not logged as player has tl' do
      week = 4
      create(:turn_actions, week: 4, club_id: 1, var1: 'deal', var2: 1, var3: 2_000_000, var4: 2, date_completed: nil)
      create(:turn_actions, week: 4, club_id: 2, var1: 'deal', var2: 1, var3: 2_000_000, var4: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1, tl: 6)

      Transfer::TransferActions.new(week).call

      expect(Transfer.all).to be_empty
      expect(Message.all.count).to eq(2)
    end
  end

  describe 'call: listed_bid' do
    it 'listed player and bid > value so log bid' do
      week = 4
      create(:turn_actions, week: 4, club_id: 1, var1: 'listed_bid', var2: 1, var3: 2_000_000, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, listed: true, value: 1_000_000)

      Transfer::TransferActions.new(week).call

      expect(Transfer.first.player_id).to eq(1)
      expect(Transfer.first.sell_club).to eq(2)
      expect(Transfer.first.buy_club).to eq(1)
      expect(Transfer.first.week).to eq(4)
      expect(Transfer.first.bid).to eq(2_000_000)
      expect(Transfer.first.status).to eq('bid')
    end

    it 'not listed player so bid_failed' do
      week = 4
      create(:turn_actions, week: 4, club_id: 1, var1: 'listed_bid', var2: 1, var3: 2_000_000, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, listed: false, value: 1_000_000)

      Transfer::TransferActions.new(week).call

      expect(Transfer.first.player_id).to eq(1)
      expect(Transfer.first.sell_club).to eq(2)
      expect(Transfer.first.buy_club).to eq(1)
      expect(Transfer.first.week).to eq(4)
      expect(Transfer.first.bid).to eq(2_000_000)
      expect(Transfer.first.status).to eq('bid_failed')
    end

    it 'listed player and bid < value so bid_failed' do
      week = 4
      create(:turn_actions, week: 4, club_id: 1, var1: 'listed_bid', var2: 1, var3: 500_000, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, listed: true, value: 1_000_000)

      Transfer::TransferActions.new(week).call

      expect(Transfer.first.player_id).to eq(1)
      expect(Transfer.first.sell_club).to eq(2)
      expect(Transfer.first.buy_club).to eq(1)
      expect(Transfer.first.week).to eq(4)
      expect(Transfer.first.bid).to eq(500_000)
      expect(Transfer.first.status).to eq('bid_failed')
    end
  end
end
