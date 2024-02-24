require 'rails_helper'
require 'pry'

RSpec.describe Turn::ClubUpdates, type: :model do
  let(:week) { 1 }
  describe 'wage_bill' do
    it 'should reduce the bank balance by the total wages of the players' do
      create(:club, id: 1, bank_bal: 0)
      create(:player, club_id: 1, wages: 100000 )
      create(:player, club_id: 1, wages: 200000 )
      create(:player, club_id: 1, wages: 300000 )

      Turn::ClubUpdates.new(week).call

      expect(Club.first.bank_bal).to eq(-600000)
    end

    it 'should not affect bank if the club has no players' do
      create(:club, id: 1, bank_bal: 0)

      Turn::ClubUpdates.new(week).call

      expect(Club.first.bank_bal).to eq(0)
    end
  end

  describe 'staff costs' do
    it 'should reduce the bank balance by the cost of the staff' do
      create(:club, id: 1,
        bank_bal: 0,
        staff_fitness: 1,
        staff_scouts: 1,
        staff_gkp: 1,
        staff_dfc: 1,
        staff_mid: 1,
        staff_att: 1
      )

      Turn::ClubUpdates.new(week).call

      expect(Club.first.bank_bal).to be_between(-67404, -55404)
    end
  end

  describe 'ground upkeep' do
    it 'should reduce the bank balance by the cost of upkeep for the stadium' do
      create(:club, id: 1,
        bank_bal: 0,
        stand_n_capacity: 5000,
        stand_s_capacity: 5000,
        stand_e_capacity: 5000,
        stand_w_capacity: 5000,
        stand_n_condition: 1,
        stand_s_condition: 1,
        stand_e_condition: 1,
        stand_w_condition: 1,
        facilities: 1,
        hospitality: 1,
        pitch: 1
      )

      allow_any_instance_of(Kernel).to receive(:rand).with(62..69).and_return(65)
      allow_any_instance_of(Kernel).to receive(:rand).with(4545..5234).and_return(5000)
      allow_any_instance_of(Kernel).to receive(:rand).with(9234..11234).and_return(10000)

      Turn::ClubUpdates.new(week).call

      expect(Club.first.bank_bal).to eq(-135000)
    end
  end
end
