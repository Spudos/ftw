require 'rails_helper'
require 'pry'

RSpec.describe Turn, type: :model do
  describe 'stadium_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, var1: 'stand_n_capacity', var2: 5000, var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'
      cost = 5000000

      Turn::TurnActions.new(week)

      allow_any_instance_of(Turn::TurnActions).to receive(:bank_adjustment)
      allow_any_instance_of(Turn::TurnActions).to receive(:add_to_stadium_upgrades)

      expect(Turn::TurnActions).to receive(:add_to_stadium_upgrades).with(action_id, week, turn.club, turn.var1, turn.var2)
      expect(Turn::TurnActions).to receive(:bank_adjustment).with(action_id, week, turn.club, turn.var1, turn.var2, cost)

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

      Turn::TurnActions.new(week).add_to_stadium_upgrades(action_id, week, club, stand, seats)

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

      Turn::TurnActions.new(week).add_to_property_upgrades(action_id, week, club, prop)

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

      Turn::TurnActions.new(week).add_to_coach_upgrades(action_id, week, club, coach)

      upgrade = Upgrade.first

      expect(upgrade[:action_id]).to eq('test')
      expect(upgrade[:week]).to eq(1)
      expect(upgrade[:club]).to eq('001')
      expect(upgrade[:var1]).to eq('dfc')
      expect(upgrade[:var2]).to eq(nil)
      expect(upgrade[:var3]).to eq(0)
    end
  end
end
