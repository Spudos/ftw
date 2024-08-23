require 'rails_helper'
require 'pry'

RSpec.describe TurnActions, type: :model do
  describe 'call: player_upgrade' do
    it 'upgrades tackling by 1 point with a sucessful random roll' do
      week = 1
      create(:turn_actions, club_id: 1, var1: 'train', var2: 402, var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_dfc: 10)
      create(:player,  id: 402, position: 'dfc')
      turn = Turn.new(week: 1)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(75)
      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.tackling).to eq(6)
    end

    it 'no upgrade due to the random roll' do
      week = 1
      create(:turn_actions, club_id: 1, var1: 'train', var2: 402, var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_dfc: 10)
      create(:player, id: 402, position: 'dfc')
      turn = Turn.new(week: 1)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(25)
      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.tackling).to eq(5)
    end

    it 'does not upgrade tackling by 1 point due to the coach being too low' do
      week = 1
      create(:turn_actions, club_id: 1, var1: 'train', var2: 402, var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_dfc: 2)
      create(:player,  id: 402, position: 'dfc')

      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.tackling).to eq(5)
    end

    it 'does not upgrade tackling by 1 point due to lack of potential' do
      week = 1
      create(:turn_actions, club_id: 1, var1: 'train', var2: 402, var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_dfc: 10)
      create(:player, id: 402, position: 'dfc', potential_tackling: 2, potential_tackling_coached: false)

      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.tackling).to eq(5)
      expect(Player.first.potential_tackling_coached).to eq(true)
    end
  end

  describe 'call: fitness_upgrade' do
    it 'upgrades fitness by 10 points' do
      week = 1
      create(:turn_actions, club_id: 1, var1: 'fitness', var2: 'Woolley', var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_fitness: 10)
      create(:player, name: 'Woolley', position: 'dfc', fitness: 50)

      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.fitness).to eq(60)
    end

    it 'upgrades fitness to 100 even though the coach is 10' do
      week = 1
      create(:turn_actions, club_id: 1, var1: 'fitness', var2: 'Woolley', var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_fitness: 10)
      create(:player, name: 'Woolley', position: 'dfc', fitness: 95)

      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.fitness).to eq(100)
    end

    it 'sets fitness at 100' do
      week = 1
      create(:turn_actions, club_id: 1, var1: 'fitness', var2: 'Woolley', var3: 'tackling', date_completed: nil)
      create(:club, id: 1, staff_fitness: 10)
      create(:player, name: 'Woolley', position: 'dfc', fitness: 120)

      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.fitness).to eq(100)
    end
  end

  describe 'call: stadium_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'stand_n_capacity', var2: 5000, var3: nil, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)

      TurnActions::TurnActionMethods.new(week).call

      expect(Club.first.bank_bal).to eq(-5_000_000)
      expect(Upgrade.first.action_id).to eq('111')
    end
  end

  describe 'call: property_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'property', var2: 'pitch', var3: 250_000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)

      TurnActions::TurnActionMethods.new(week).call

      expect(Club.first.bank_bal).to eq(-250_000)
      expect(Upgrade.first.action_id).to eq('111')
    end
  end

  describe 'call: coach_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'coach', var2: 'dfc', var3: 500_000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)

      TurnActions::TurnActionMethods.new(week).call

      expect(Club.first.bank_bal).to eq(-500_000)
      expect(Upgrade.first.action_id).to eq("111")
    end
  end

  describe 'call: contract_renewal' do
    it 'renews the contract due to high loyalty' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'contract', var2: 1, var3: 0, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:player, id: 1, club_id: 1, contract: 0, loyalty: 100)

      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.contract).to eq(24)
      expect(Club.first.bank_bal).to eq(0)
    end

    it 'renews the contract due to high loyalty and reduces the bank by the incentive' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'contract', var2: 1, var3: 500_000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:player, id: 1, club_id: 1, loyalty: 100, contract: 0)

      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.contract).to eq(24)
      expect(Club.first.bank_bal).to eq(-500_000)
    end

    it 'renewal fails due to low loyalty and loyalty reduces by 5' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'contract', var2: 1, var3: 0, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:player, id: 1, club_id: 1, loyalty: 6, contract: 0)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(50)

      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.loyalty).to eq(1)
      expect(Player.first.contract).to eq(0)
    end
  end

  describe 'call: loyalty_increase' do
    it 'renews the contract due to high loyalty' do
      week = 1
      create(:turn_actions, week: 1, club_id: 1, var1: 'loyalty', var2: 1, var3: 500_000, date_completed: nil)
      create(:club, id: 1, bank_bal: 0)
      create(:player, id: 1, club_id: 1, contract: 0, loyalty: 50)

      TurnActions::TurnActionMethods.new(week).call

      expect(Player.first.loyalty).to eq(55)
      expect(Club.first.bank_bal).to eq(-500_000)
    end
  end
end
