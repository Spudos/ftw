require 'rails_helper'
require 'pry'

RSpec.describe Turn, type: :model do
  describe 'call: unmanaged_bid' do
    it 'bid fails as the player belongs to a managed club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unmanaged_bid', var2: 1, var3: 1000001, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0, managed: true)
      create(:player, id: 1, club_id: 2, value: 1000000, loyalty: 10, total_skill: 76)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(15)

      Turn::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(2)
      expect(Club.first.bank_bal).to eq(0)
      expect(Club.last.bank_bal).to eq(0)
    end

    it 'rand roll higher than loyalty and value higher than threshold so player moves to club 1 and deduct sale proceeds from buying club bank and add to selling club bank' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unmanaged_bid', var2: 1, var3: 1500000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:player, id: 1, club_id: 2, value: 1000000, loyalty: 10)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(15)

      Turn::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(1)
      expect(Club.first.bank_bal).to eq(-1500000)
      expect(Club.last.bank_bal).to eq(1500000)
    end

    it 'rand roll higher than loyalty and bid lower than threshold so player and club details dont change' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unmanaged_bid', var2: 1, var3: 500000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:player, id: 1, club_id: 2, value: 1000000, loyalty: 10)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(15)

      Turn::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(2)
      expect(Club.first.bank_bal).to eq(0)
      expect(Club.last.bank_bal).to eq(0)
    end

    it 'rand roll lower than loyalty so player and club details dont change' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unmanaged_bid', var2: 1, var3: 1500000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:player, id: 1, club_id: 2, value: 1000000, loyalty: 10)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(5)

      Turn::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(2)
      expect(Club.first.bank_bal).to eq(0)
      expect(Club.last.bank_bal).to eq(0)
    end
  end

  describe 'call: circuit_sale' do
    it 'move the player to club 242 and adds 75% value to the selling club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'circuit', var2: 1, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 242, bank_bal: 0)
      create(:player, id: 1, club_id: 1, value: 1000000)

      Turn::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(242)
      expect(Club.first.bank_bal).to eq(750000)
    end

    it 'no change to player club or club funds as he doesnt belong to the selling club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'circuit', var2: 1, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:player, id: 1, club_id: 2, value: 1000000)

      Turn::TransferActions.new(week).call

      expect(Player.first.club_id).to eq(2)
      expect(Club.first.bank_bal).to eq(0)
    end
  end

  describe 'call: list_player' do
    it 'player status change to listed:true' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'list', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1, listed: false)

      Turn::TransferActions.new(week).call

      expect(Player.first.listed).to eq(true)
    end

    it 'no listed status change if player is not owned by the club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'list', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, listed: false)

      Turn::TransferActions.new(week).call

      expect(Player.first.listed).to eq(false)
    end
  end

  describe 'call: unlist_player' do
    it 'player status change to listed:false and set loyalty to 5' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unlist', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1, loyalty: 10, listed: true)

      Turn::TransferActions.new(week).call

      expect(Player.first.listed).to eq(false)
      expect(Player.first.loyalty).to eq(5)
    end

    it 'no listed status change if player is not owned by the club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unlist', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, loyalty: 10, listed: true)

      Turn::TransferActions.new(week).call

      expect(Player.first.listed).to eq(true)
      expect(Player.first.loyalty).to eq(10)
    end

    it 'no listed status change if player is not listed by the club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unlist', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1, loyalty: 10, listed: false)

      Turn::TransferActions.new(week).call

      expect(Player.first.listed).to eq(false)
      expect(Player.first.loyalty).to eq(10)
    end
  end
end
