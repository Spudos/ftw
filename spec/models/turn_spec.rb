require 'rails_helper'
require 'pry'

RSpec.describe Turn, type: :model do
  describe 'contract_decrease' do
    it 'reduces the contract by 1' do
      create(:player, contract: 20)

      adjusted_player = Turn.new.send(:contract_decrease)

      expect(adjusted_player[0][:contract]).to eq(19)
    end

    it 'does not reduce the contract past 0' do
      create(:player, contract: 0)

      adjusted_player = Turn.new.send(:contract_decrease)

      expect(adjusted_player[0][:contract]).to eq(0)
    end

    it 'sets the contract to 0 as it was negative' do
      create(:player, contract: -20)

      adjusted_player = Turn.new.send(:contract_decrease)

      expect(adjusted_player[0][:contract]).to eq(0)
    end
  end

  describe 'fitness increase' do
    it 'does not effect fitness' do
      create(:player, fitness: 100)

      adjusted_player = Turn.new.send(:fitness_increase)

      expect(adjusted_player[0][:fitness]).to eq(100)
    end

    it 'sets fitness to 100' do
      create(:player, fitness: 110)

      adjusted_player = Turn.new.send(:fitness_increase)

      expect(adjusted_player[0][:fitness]).to eq(100)
    end

    it 'increases the fitness by 3' do
      create(:player, fitness: 0)
      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)

      adjusted_player = Turn.new.send(:fitness_increase)

      expect(adjusted_player[0][:fitness]).to eq(3)
    end
  end

  describe 'add_to_property_upgrades' do
    it 'adds the upgrade to the upgrade table' do
      action_id = 'test'
      week = 1
      club = '001'
      prop = 'pitch'

      Turn.new.send(:add_to_property_upgrades, action_id, week, club, prop)

      upgrade = Upgrade.first

      expect(upgrade[:action_id]).to eq('test')
      expect(upgrade[:week]).to eq(1)
      expect(upgrade[:club]).to eq('001')
      expect(upgrade[:var1]).to eq('pitch')
      expect(upgrade[:var2]).to eq(nil)
      expect(upgrade[:var3]).to eq(0)
    end
  end

  describe 'add_to_coach_upgrades' do
    it 'adds the upgrade to the upgrade table' do
      action_id = 'test'
      week = 1
      club = '001'
      coach = 'dfc'

      Turn.new.send(:add_to_coach_upgrades, action_id, week, club, coach)

      upgrade = Upgrade.first

      expect(upgrade[:action_id]).to eq('test')
      expect(upgrade[:week]).to eq(1)
      expect(upgrade[:club]).to eq('001')
      expect(upgrade[:var1]).to eq('dfc')
      expect(upgrade[:var2]).to eq(nil)
      expect(upgrade[:var3]).to eq(0)
    end
  end

  describe 'increment_upgrades' do
    it 'increases the upgrade var 3 value by 1' do
      create(:upgrade, var3: 0)

      Turn.new.send(:increment_upgrades)

      upgrade = Upgrade.first

      expect(upgrade[:var3]).to eq(1)
    end

    it 'increases the upgrade var 3 value by 1 and calls perform_completed_upgrades if var3 is now 6' do
      create(:upgrade, var3: 5)
      turn = Turn.new

      expect(turn).to receive(:perform_completed_upgrades)

      turn.send(:increment_upgrades)
    end
  end
end
