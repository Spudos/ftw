require 'rails_helper'
require 'pry'

RSpec.describe Turn, type: :model do
  describe 'call: player_upgrade' do
    it 'upgrades tackling by 1 point' do
      week = 1
      create(:turn, club_id: 1, var1: 'train', var2: 'Woolley', var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_dfc: 10)
      create(:player, name: 'Woolley', position: 'dfc')

      Turn::TurnActions.new(week).call

      expect(Player.first.tackling).to eq(6)
    end

    it 'does not upgrade tackling by 1 point due to the coach being too low' do
      week = 1
      create(:turn, club_id: 1, var1: 'train', var2: 'Woolley', var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_dfc: 2)
      create(:player, name: 'Woolley', position: 'dfc')

      Turn::TurnActions.new(week).call

      expect(Player.first.tackling).to eq(5)
    end

    it 'does not upgrade tackling by 1 point due to lack of potential' do
      week = 1
      create(:turn, club_id: 1, var1: 'train', var2: 'Woolley', var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_dfc: 10)
      create(:player, name: 'Woolley', position: 'dfc', potential_tackling: 2)

      Turn::TurnActions.new(week).call

      expect(Player.first.tackling).to eq(5)
    end
  end

  describe 'call: fitness_upgrade' do
    it 'upgrades fitness by 10 points' do
      week = 1
      create(:turn, club_id: 1, var1: 'fitness', var2: 'Woolley', var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_fitness: 10)
      create(:player, name: 'Woolley', position: 'dfc', fitness: 50)

      Turn::TurnActions.new(week).call

      expect(Player.first.fitness).to eq(60)
    end

    it 'upgrades fitness to 100 even though the coach is 10' do
      week = 1
      create(:turn, club_id: 1, var1: 'fitness', var2: 'Woolley', var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_fitness: 10)
      create(:player, name: 'Woolley', position: 'dfc', fitness: 95)

      Turn::TurnActions.new(week).call

      expect(Player.first.fitness).to eq(100)
    end

    it 'sets fitness at 100' do
      week = 1
      create(:turn, club_id: 1, var1: 'fitness', var2: 'Woolley', var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_fitness: 10)
      create(:player, name: 'Woolley', position: 'dfc', fitness: 120)

      Turn::TurnActions.new(week).call

      expect(Player.first.fitness).to eq(100)
    end
  end

  describe 'call: unmanaged_bid' do
    it 'bid fails as the player belongs to a managed club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unmanaged_bid', var2: 1, var3: 1000001, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0, managed: true)
      create(:player, id: 1, club_id: 2, value: 1000000, loyalty: 10, total_skill: 76)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(15)

      Turn::TurnActions.new(week).call

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

      Turn::TurnActions.new(week).call

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

      Turn::TurnActions.new(week).call

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

      Turn::TurnActions.new(week).call

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

      Turn::TurnActions.new(week).call

      expect(Player.first.club_id).to eq(242)
      expect(Club.first.bank_bal).to eq(750000)
    end

    it 'no change to player club or club funds as he doesnt belong to the selling club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'circuit', var2: 1, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:club, id: 2, bank_bal: 0)
      create(:player, id: 1, club_id: 2, value: 1000000)

      Turn::TurnActions.new(week).call

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

      Turn::TurnActions.new(week).call

      expect(Player.first.listed).to eq(true)
    end

    it 'no listed status change if player is not owned by the club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'list', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, listed: false)

      Turn::TurnActions.new(week).call

      expect(Player.first.listed).to eq(false)
    end
  end

  describe 'call: unlist_player' do
    it 'player status change to listed:false and set loyalty to 5' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unlist', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1, loyalty: 10, listed: true)

      Turn::TurnActions.new(week).call

      expect(Player.first.listed).to eq(false)
      expect(Player.first.loyalty).to eq(5)
    end

    it 'no listed status change if player is not owned by the club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unlist', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:club, id: 2)
      create(:player, id: 1, club_id: 2, loyalty: 10, listed: true)

      Turn::TurnActions.new(week).call

      expect(Player.first.listed).to eq(true)
      expect(Player.first.loyalty).to eq(10)
    end

    it 'no listed status change if player is not listed by the club' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'unlist', var2: 1, date_completed: nil)
      create(:club, id: 1)
      create(:player, id: 1, club_id: 1, loyalty: 10, listed: false)

      Turn::TurnActions.new(week).call

      expect(Player.first.listed).to eq(false)
      expect(Player.first.loyalty).to eq(10)
    end
  end

  describe 'call: stadium_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'stand_n_capacity', var2: 5000, var3: nil, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)

      Turn::TurnActions.new(week).call

      expect(Club.first.bank_bal).to eq(-5000000)
      expect(Upgrade.first.action_id).to eq("111")
    end
  end

  describe 'call: property_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'property', var2: "pitch", var3: 250000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)

      Turn::TurnActions.new(week).call

      expect(Club.first.bank_bal).to eq(-250000)
      expect(Upgrade.first.action_id).to eq("111")
    end
  end

  describe 'call: coach_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'coach', var2: 'dfc', var3: 500000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)

      Turn::TurnActions.new(week).call

      expect(Club.first.bank_bal).to eq(-500000)
      expect(Upgrade.first.action_id).to eq("111")
    end
  end

  describe 'call: contract_renewal' do
    it 'renews the contract due to high loyalty' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'contract', var2: 1, var3: 0, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:player, id: 1, club_id: 1, contract: 0, loyalty: 100)

      Turn::TurnActions.new(week).call

      expect(Player.first.contract).to eq(24)
      expect(Club.first.bank_bal).to eq(0)
    end

    it 'renews the contract due to high loyalty and reduces the bank by the incentive' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'contract', var2: 1, var3: 500000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:player, id: 1, club_id: 1, loyalty: 100, contract: 0)

      Turn::TurnActions.new(week).call

      expect(Player.first.contract).to eq(24)
      expect(Club.first.bank_bal).to eq(-500000)
    end

    it 'renewal fails due to low loyalty and loyalty reduces by 5' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'contract', var2: 1, var3: 0, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:player, id: 1, club_id: 1, loyalty: 6, contract: 0)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(50)

      Turn::TurnActions.new(week).call

      expect(Player.first.loyalty).to eq(1)
      expect(Player.first.contract).to eq(0)
    end
  end

  describe 'call: loyalty_increase' do
    it 'renews the contract due to high loyalty' do
      week = 1
      create(:turn, week: 1, club_id: 1, var1: 'loyalty', var2: 1, var3: 500000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:player, id: 1, club_id: 1, contract: 0, loyalty: 50)

      Turn::TurnActions.new(week).call

      expect(Player.first.loyalty).to eq(55)
      expect(Club.first.bank_bal).to eq(-500000)
    end
  end
end