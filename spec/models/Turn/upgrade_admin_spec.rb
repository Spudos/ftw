require 'rails_helper'
require 'pry'

RSpec.describe Turn, type: :model do
  describe 'perform_completed_upgrades' do
    let(:week) { 1 }
    it 'performs the upgrade increase for staff' do
      create(:club, staff_dfc: 1)
      item = create(:upgrade, var1: 'staff_dfc', action_id: '10011')

      Turn::UpgradeAdmin.new(week).perform_completed_upgrades(item, week)

      expect(Club.first[:staff_dfc]).to eq(2)
      expect(Message.first[:var1]).to eq("Your upgrade to the #{item.var1} was completed, the new value is #{Club.first[:staff_dfc]}")
    end

    it 'performs the upgrade increase for facilities' do
      create(:club, facilities: 1)
      item = create(:upgrade, var1: 'facilities', action_id: '10011')

      Turn::UpgradeAdmin.new(week).perform_completed_upgrades(item, week)

      expect(Club.first[:facilities]).to eq(2)
      expect(Message.first[:var1]).to eq("Your upgrade to the #{item.var1} was completed, the new value is #{Club.first[:facilities]}")
    end

    it 'performs the upgrade increase for hospitality' do
      create(:club, hospitality: 1)
      item = create(:upgrade, var1: 'hospitality', action_id: '10011')

      Turn::UpgradeAdmin.new(week).perform_completed_upgrades(item, week)

      expect(Club.first[:hospitality]).to eq(2)
      expect(Message.first[:var1]).to eq("Your upgrade to the #{item.var1} was completed, the new value is #{Club.first[:hospitality]}")
    end

    it 'performs the upgrade increase for pitch' do
      create(:club, pitch: 1)
      item = create(:upgrade, var1: 'pitch', action_id: '10011')

      Turn::UpgradeAdmin.new(week).perform_completed_upgrades(item, week)

      expect(Club.first[:pitch]).to eq(2)
      expect(Message.first[:var1]).to eq("Your upgrade to the #{item.var1} was completed, the new value is #{Club.first[:pitch]}")
    end

    it 'performs the upgrade increase for stand condition' do
      create(:club, stand_n_condition: 1)
      item = create(:upgrade, var1: 'stand_n_condition', action_id: '10011')

      Turn::UpgradeAdmin.new(week).perform_completed_upgrades(item, week)

      expect(Club.first[:stand_n_condition]).to eq(2)
      expect(Message.first[:var1]).to eq("Your upgrade to the #{item.var1} was completed, the new value is #{Club.first[:stand_n_condition]}")
    end

    it 'performs the upgrade increase for stand condition' do
      create(:club, stand_n_capacity: 5000, stand_n_name: 'north stand')
      item = create(:upgrade, var1: 'stand_n_capacity', var2: 5000, action_id: '10011')

      Turn::UpgradeAdmin.new(week).perform_completed_upgrades(item, week)

      expect(Club.first[:stand_n_capacity]).to eq(10000)
      expect(Message.first[:var1]).to eq("Your upgrade to the #{Club.first[:stand_n_name]} was completed, the new value is #{Club.first[:stand_n_capacity]}")
    end

    it 'should perform completed upgrades for items with var3 equal to 6' do
      upgrade = Upgrade.create(var3: 5)
      
      Turn::UpgradeAdmin.call

      expect(upgrade.reload.var3).to eq(6)

      expect(self).to have_received(:perform_completed_upgrades).with(upgrade, week)
    end
  end
end
