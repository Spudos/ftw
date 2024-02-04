require 'rails_helper'
require 'pry'

RSpec.describe Turn, type: :model do
  describe 'stadium_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, var1: 'stand_n_capacity', var2: 5000, var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'
      cost = 5000000

      allow_any_instance_of(Turn).to receive(:bank_adjustment)
      allow_any_instance_of(Turn).to receive(:add_to_stadium_upgrades)

      expect(turn).to receive(:add_to_stadium_upgrades).with(action_id, week, turn.club, turn.var1, turn.var2)
      expect(turn).to receive(:bank_adjustment).with(action_id, week, turn.club, turn.var1, turn.var2, cost)

      turn.send(:stadium_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club]).to eq('001')
      expect(Turn.first[:var1]).to eq('stand_n_capacity')
      expect(Turn.first[:var2]).to eq('5000')
      expect(Turn.first[:var3]).to eq(nil)
      expect(Turn.first[:date_completed]).to_not be_nil
    end
  end

  describe 'add_to_stadium_upgrades' do
    it 'adds the upgrade to the upgrade table' do
      action_id = 'test'
      week = 1
      club = '001'
      stand = 'stand_n_capacity'
      seats = 5000

      Turn.new.send(:add_to_stadium_upgrades, action_id, week, club, stand, seats)

      upgrade = Upgrade.first

      expect(upgrade[:action_id]).to eq('test')
      expect(upgrade[:week]).to eq(1)
      expect(upgrade[:club]).to eq('001')
      expect(upgrade[:var1]).to eq('stand_n_capacity')
      expect(upgrade[:var2]).to eq('5000')
      expect(upgrade[:var3]).to eq(0)
    end
  end

  describe 'property_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, var1: 'property', var2: 'pitch', var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'

      allow_any_instance_of(Turn).to receive(:bank_adjustment)
      allow_any_instance_of(Turn).to receive(:add_to_property_upgrades)

      expect(turn).to receive(:bank_adjustment).with(action_id, week, turn.club, turn.var1, turn.var2, turn.var3)
      expect(turn).to receive(:add_to_property_upgrades).with(action_id, week, turn.club, turn.var2)

      turn.send(:property_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club]).to eq('001')
      expect(Turn.first[:var1]).to eq('property')
      expect(Turn.first[:var2]).to eq('pitch')
      expect(Turn.first[:var3]).to eq(nil)
      expect(Turn.first[:date_completed]).to_not be_nil
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

  describe 'coach_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, var1: 'coach', var2: 'dfc', var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'

      allow_any_instance_of(Turn).to receive(:bank_adjustment)
      allow_any_instance_of(Turn).to receive(:add_to_coach_upgrades)

      expect(turn).to receive(:bank_adjustment).with(action_id, week, turn.club, turn.var1, turn.var2, turn.var3)
      expect(turn).to receive(:add_to_coach_upgrades).with(action_id, week, turn.club, turn.var2)

      turn.send(:coach_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club]).to eq('001')
      expect(Turn.first[:var1]).to eq('coach')
      expect(Turn.first[:var2]).to eq('dfc')
      expect(Turn.first[:var3]).to eq(nil)
      expect(Turn.first[:date_completed]).to_not be_nil
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

  describe 'player_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, var1: 'train', var2: 'Woolley', var3: 'Tackling', date_completed: nil)
      week = 1
      action_id = '10011'

      allow_any_instance_of(Turn).to receive(:train_player)

      expect(turn).to receive(:train_player).with(action_id, week, turn.club, turn.var2, turn.var3)

      turn.send(:player_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club]).to eq('001')
      expect(Turn.first[:var1]).to eq('train')
      expect(Turn.first[:var2]).to eq('Woolley')
      expect(Turn.first[:var3]).to eq('Tackling')
      expect(Turn.first[:date_completed]).to_not be_nil
    end
  end

  describe 'train_player' do
   
  end

  describe 'fitness_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, var1: 'fitness', var2: 'Woolley', var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'

      allow_any_instance_of(Turn).to receive(:player_fitness)

      expect(turn).to receive(:player_fitness).with(action_id, week, turn.club, turn.var2)

      turn.send(:fitness_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club]).to eq('001')
      expect(Turn.first[:var1]).to eq('fitness')
      expect(Turn.first[:var2]).to eq('Woolley')
      expect(Turn.first[:var3]).to eq(nil)
      expect(Turn.first[:date_completed]).to_not be_nil
    end
  end

  describe 'player_fitness' do
   
  end

  describe 'bank_adjustment' do
   
  end

  describe 'perform_completed_upgrades' do
   
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
end
