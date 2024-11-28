require 'rails_helper'
require 'pry'

RSpec.describe Club::UpgradeAdmin, type: :model do
  let(:week) { 1 }
  describe 'increment upgrade' do
    it 'should increase the upgrade value by 1 and do nothing else until it reaches 6' do
      Upgrade.create(var3: 3)

      Club::UpgradeAdmin.new(week).call

      expect(Upgrade.first.var3).to eq(4)
    end
  end

  describe 'perform_completed_upgrades' do
    it 'performs the upgrade increase for staff' do
      create(:club, staff_dfc: 1)
      create(:upgrade, week: 1, club_id: Club.first.id, var1: 'staff_dfc', action_id: '10011', var3: 5)

      Club::UpgradeAdmin.new(week).call

      expect(Club.first[:staff_dfc]).to eq(2)
    end

    it 'performs the upgrade increase for facilities' do
      create(:club, facilities: 1)
      create(:upgrade, week: 1, club_id: Club.first.id, var1: 'facilities', action_id: '10011', var3: 5)

      Club::UpgradeAdmin.new(week).call

      expect(Club.first[:facilities]).to eq(2)
    end

    it 'performs the upgrade increase for hospitality' do
      create(:club, hospitality: 1)
      create(:upgrade, week: 1, club_id: Club.first.id, var1: 'hospitality', action_id: '10011', var3: 5)

      Club::UpgradeAdmin.new(week).call

      expect(Club.first[:hospitality]).to eq(2)
    end

    it 'performs the upgrade increase for pitch' do
      create(:club, pitch: 1)
      create(:upgrade, week: 1, club_id: Club.first.id, var1: 'pitch', action_id: '10011', var3: 5)

      Club::UpgradeAdmin.new(week).call

      expect(Club.first[:pitch]).to eq(2)
    end

    it 'performs the upgrade increase for stand condition' do
      create(:club, stand_n_condition: 1)
      create(:upgrade, week: 1, club_id: Club.first.id, var1: 'stand_n_condition', action_id: '10011', var3: 5)

      Club::UpgradeAdmin.new(week).call

      expect(Club.first[:stand_n_condition]).to eq(2)
    end

    it 'performs the upgrade increase for stand condition' do
      create(:club, stand_n_capacity: 5000, stand_n_name: 'north stand')
      create(:upgrade, week: 1, club_id: Club.first.id, var1: 'stand_n_capacity', var2: 5000, action_id: '10011', var3: 5)

      Club::UpgradeAdmin.new(week).call

      expect(Club.first[:stand_n_capacity]).to eq(10_000)
    end
  end
end
