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
        pitch: 1,
        fanbase: 30000,
        ticket_price: 10
      )

      allow_any_instance_of(Kernel).to receive(:rand).with(62..69).and_return(65)
      allow_any_instance_of(Kernel).to receive(:rand).with(4545..5234).and_return(5000)

      Turn::ClubUpdates.new(week).send(:ground_upkeep)

      expect(Club.first.bank_bal).to eq(-135000)
    end
  end

  describe 'club shop income' do
    it 'should increase the bank balance by the sales during the week' do
      create(:club, id: 1,
        bank_bal: 0,
        fanbase: 100000
      )

      Turn::ClubUpdates.new(week).call

      expect(Club.first.bank_bal).to be_between(107123, 112123)
    end
  end

  describe 'Match_income' do
    it 'should increase the bank balance all streams of income for a match day' do
      create(:match)
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
        pitch: 1,
        fan_happiness: 50,
        fanbase: 100000,
        ticket_price: 10
      )

      Turn::ClubUpdates.new(week).send(:match_day_income)

      expect(Club.first.bank_bal).to be_between(273960, 310083)
    end

    it 'does not effect bank as no home game' do
      create(:club, id: 3,
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
        pitch: 1,
        fan_happiness: 50,
        fanbase: 100000,
        ticket_price: 10
      )

      Turn::ClubUpdates.new(week).send(:match_day_income)

      expect(Club.first.bank_bal).to eq(0)
    end
  end

  describe 'fan_happiness_match' do
    it 'adjust fan happiness depending on the match result (win for club 1)' do
      create(:club, id: 1,
        fan_happiness: 50
      )
      create(:club, id: 2,
        fan_happiness: 50
      )
      create(:match, home_goals: 3, away_goals: 1)

      Turn::ClubUpdates.new(week).send(:fan_happiness_match)

      expect(Club.first.fan_happiness).to eq(59)
      expect(Club.last.fan_happiness).to eq(45)
    end

    it 'adjust fan happiness depending on the match result (win for club 2)' do
      create(:club, id: 1,
        fan_happiness: 50
      )
      create(:club, id: 2,
        fan_happiness: 50
      )
      create(:match, home_goals: 3, away_goals: 4)

      Turn::ClubUpdates.new(week).send(:fan_happiness_match)

      expect(Club.first.fan_happiness).to eq(45)
      expect(Club.last.fan_happiness).to eq(59)
    end

    it 'adjust fan happiness depending on the match result (draw)' do
      create(:club, id: 1,
        fan_happiness: 50
      )
      create(:club, id: 2,
        fan_happiness: 50
      )
      create(:match, home_goals: 3, away_goals: 3)

      Turn::ClubUpdates.new(week).send(:fan_happiness_match)

      expect(Club.first.fan_happiness).to eq(53)
      expect(Club.last.fan_happiness).to eq(53)
    end
  end

  describe 'fan_happiness_signings' do
    it 'adjust fan happiness if a player is signed' do
      create(:club, id: 2,
        fan_happiness: 50
      )

      create(:transfer, player_id: 1, status: 'completed', week: 1)

      Turn::ClubUpdates.new(week).send(:fan_happiness_signings)

      expect(Club.first.fan_happiness).to eq(56)
    end
  end

  describe 'fan_happiness_bank' do
    it 'adjust fan happiness up by 3 as the club is rich' do
      create(:club, id: 2,
        bank_bal: 100000000,
        fan_happiness: 50
      )
      Turn::ClubUpdates.new(week).send(:fan_happiness_bank)

      expect(Club.first.fan_happiness).to eq(53)
    end

    it 'adjust fan happiness down by 5 as the club is poor' do
      create(:club, id: 2,
        bank_bal: 1000000,
        fan_happiness: 50
      )

      Turn::ClubUpdates.new(week).send(:fan_happiness_bank)

      expect(Club.first.fan_happiness).to eq(45)
    end

    it 'no fan happiness change' do
      create(:club, id: 2,
        bank_bal: 50000000,
        fan_happiness: 50
      )

      Turn::ClubUpdates.new(week).send(:fan_happiness_bank)

      expect(Club.first.fan_happiness).to eq(50)
    end
  end

  describe 'fan_happiness_random' do
    it 'adjust fan happiness by a randoim amount and make sure it is 0 to 100' do
      create(:club, id: 2,
        fan_happiness: 50
      )
      allow_any_instance_of(Kernel).to receive(:rand).with(-3..3).and_return(1)
      Turn::ClubUpdates.new(week).send(:fan_happiness_random)

      expect(Club.first.fan_happiness).to eq(51)
    end

    it 'corrects a high amount to 100' do
      create(:club, id: 2,
        fan_happiness: 250
      )

      Turn::ClubUpdates.new(week).send(:fan_happiness_random)

      expect(Club.first.fan_happiness).to eq(100)
    end

    it 'corrects a minus amount to 0' do
      create(:club, id: 2,
        fan_happiness: -50
      )

      Turn::ClubUpdates.new(week).send(:fan_happiness_random)

      expect(Club.first.fan_happiness).to eq(0)
    end
  end
end
