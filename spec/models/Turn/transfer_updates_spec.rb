require 'rails_helper'
require 'pry'

RSpec.describe Turn::TransferUpdates, type: :model do
  describe '#call: listed_player_bids' do
    let(:week) { 1 }
    it 'single listed player transfer bids actioned' do
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 3, bid: 10000000)

      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 3, bank_bal: 0)

      create(:player, id: 1, club_id: 1, contract: 10)

      Turn::TransferUpdates.new(week).call

      expect(Player.first.club_id).to eq(3)
      expect(Player.first.contract).to eq(24)
      expect(Club.find(1).bank_bal).to eq(10000000)
      expect(Club.find(3).bank_bal).to eq(-10000000)
    end
    it 'multiple listed player transfer bids actioned' do
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 3, bid: 10000000)
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 4, bid: 15000000)
      create(:transfer, player_id: 2, sell_club: 2, buy_club: 3, bid: 45000000)
      create(:transfer, player_id: 2, sell_club: 2, buy_club: 4, bid: 35000000)

      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:club, id: 3, bank_bal: 0)
      create(:club, id: 4, bank_bal: 0)

      create(:player, id: 1, club_id: 1, contract: 10)
      create(:player, id: 2, club_id: 2, contract: 10)

      Turn::TransferUpdates.new(week).call

      expect(Player.first.club_id).to eq(4)
      expect(Player.first.contract).to eq(24)
      expect(Player.last.club_id).to eq(3)
      expect(Player.last.contract).to eq(24)
      expect(Club.find(1).bank_bal).to eq(15000000)
      expect(Club.find(2).bank_bal).to eq(45000000)
      expect(Club.find(3).bank_bal).to eq(-45000000)
      expect(Club.find(4).bank_bal).to eq(-15000000)
    end
  end

  describe '#call: deal between two clubs' do
    let(:week) { 1 }
    it 'valid conditions so transfer completed' do
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 2, bid: 10000000, status: 'deal')
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 2, bid: 10000000, status: 'deal')

      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)

      create(:player, id: 1, club_id: 1, contract: 10, value: 500000)

      Turn::TransferUpdates.new(week).call

      expect(Player.first.club_id).to eq(2)
      expect(Player.first.contract).to eq(24)
      expect(Club.find(1).bank_bal).to eq(10000000)
      expect(Club.find(2).bank_bal).to eq(-10000000)
    end

    it 'fails due to different amounts recorded' do
      create(:transfer, player_id: 2, sell_club: 1, buy_club: 2, bid: 10000000, status: 'deal')
      create(:transfer, player_id: 2, sell_club: 1, buy_club: 2, bid: 15000000, status: 'deal')

      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)

      create(:player, id: 2, club_id: 1, contract: 10)

      Turn::TransferUpdates.new(week).call

      expect(Player.first.club_id).to eq(1)
      expect(Player.first.contract).to eq(10)
      expect(Club.find(1).bank_bal).to eq(0)
      expect(Club.find(2).bank_bal).to eq(0)
    end

    it 'fails due to player not owned by selling club' do
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 2, bid: 10000000, status: 'deal')
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 2, bid: 10000000, status: 'deal')

      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:club, id: 3, bank_bal: 0)

      create(:player, id: 1, club_id: 3, contract: 10)

      Turn::TransferUpdates.new(week).call

      expect(Player.first.club_id).to eq(3)
      expect(Player.first.contract).to eq(10)
      expect(Club.find(1).bank_bal).to eq(0)
      expect(Club.find(2).bank_bal).to eq(0)
      expect(Club.find(3).bank_bal).to eq(0)
    end

    it 'fails as the agreed amount is lower than the player value' do
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 2, bid: 10000000, status: 'deal')
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 2, bid: 10000000, status: 'deal')

      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)

      create(:player, id: 1, club_id: 1, contract: 10, value: 20000000)

      Turn::TransferUpdates.new(week).call

      expect(Player.first.club_id).to eq(1)
      expect(Player.first.contract).to eq(10)
      expect(Club.find(1).bank_bal).to eq(0)
      expect(Club.find(2).bank_bal).to eq(0)
    end

    it 'fails as the only one club logs the deal' do
      create(:transfer, player_id: 1, sell_club: 1, buy_club: 2, bid: 10000000, status: 'deal')

      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)

      create(:player, id: 1, club_id: 1, contract: 10, value: 5000)

      Turn::TransferUpdates.new(week).call

      expect(Player.first.club_id).to eq(1)
      expect(Player.first.contract).to eq(10)
      expect(Club.find(1).bank_bal).to eq(0)
      expect(Club.find(2).bank_bal).to eq(0)
    end
  end
end
