require 'rails_helper'
require 'pry'

RSpec.describe Turn::ClubUpdates, type: :model do
  let(:week) { 1 }

  describe 'wage_bill' do
    it 'should reduce the bank balance by the total wages of the players' do
      create(:club, id: 1, bank_bal: 1_000_000)
      create(:player, club_id: 1, wages: 100_000)
      create(:player, club_id: 1, wages: 200_000)
      create(:player, club_id: 1, wages: 300_000)
      club = Club.first
      club_messages = []

      Turn::Engines::ClubWageBill.new(week, club, club_messages).process

      expect(Club.first.bank_bal).to eq(400_000)
      expect(Club.first.overdrawn).to eq(0)
    end

    it 'should not affect bank if the club has no players' do
      create(:club, id: 1, bank_bal: 0)
      club = Club.first
      club_messages = []

      Turn::Engines::ClubWageBill.new(week, club, club_messages).process

      expect(Club.first.bank_bal).to eq(0)
    end
  end

  describe 'staff costs' do
    it 'should reduce the bank balance by the cost of the staff' do
      create(:club,
             id: 1,
             bank_bal: 0,
             staff_fitness: 1,
             staff_scouts: 1,
             staff_gkp: 1,
             staff_dfc: 1,
             staff_mid: 1,
             staff_att: 1)

      club = Club.first
      club_messages = []

      Turn::Engines::ClubStaffCosts.new(week, club, club_messages).process

      expect(Club.first.bank_bal).to be_between(-67_404, -55_404)
    end
  end

  describe 'ground upkeep' do
    it 'should reduce the bank balance by the cost of upkeep for the stadium' do
      create(:club,
             id: 1,
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
             fanbase: 30_000,
             ticket_price: 10)

      allow_any_instance_of(Kernel).to receive(:rand).with(62..69).and_return(65)
      allow_any_instance_of(Kernel).to receive(:rand).with(1845..2434).and_return(2200)
      club = Club.first
      club_messages = []

      Turn::Engines::ClubGroundUpkeep.new(week, club, club_messages).process

      expect(Club.first.bank_bal).to eq(-66_600)
    end
  end

  describe 'club shop income' do
    it 'should increase the bank balance by the sales during the week' do
      create(:club,
             id: 1,
             bank_bal: 0,
             fanbase: 100_000)
      club = Club.first
      club_messages = []

      Turn::Engines::ClubShopIncome.new(week, club, club_messages).process

      expect(Club.first.bank_bal).to be_between(107_123, 112_123)
    end
  end

  describe 'calcualte attendance' do
    it 'calculate the attandance for the match and update it in the matches table' do
      create(:match)
      create(:club,
             id: 1,
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
             fanbase: 30_000,
             ticket_price: 10)

      allow_any_instance_of(Kernel).to receive(:rand).with(0.9756..0.9923).and_return(0.99)

      Turn::Engines::CalculateAttendances.new(week).process

      expect(Match.first.attendance).to eq(19_800)
    end
  end

  describe 'Match_income' do
    it 'should increase the bank balance all streams of income for a match day' do
      create(:match)
      create(:club,
             id: 1,
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
             ticket_price: 10)

      allow_any_instance_of(Kernel).to receive(:rand).with(0.9756..0.9923).and_return(0.99)
      allow_any_instance_of(Kernel).to receive(:rand).with(102_345..119_234).and_return(105_000)
      allow_any_instance_of(Kernel).to receive(:rand).with(12_345..19_234).and_return(15_000)

      club_updates = []
      resolver = Turn::Engines::MessageTypeResolver.new(club_updates)
      Turn::Engines::ClubMatchDayIncome.new(week, resolver).process

      expect(Club.first.bank_bal).to eq(705_071)
    end

    it 'does not effect bank as no home game' do
      create(:club,
             id: 3,
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
             fanbase: 100_000,
             ticket_price: 10)

      club_updates = []
      resolver = Turn::Engines::MessageTypeResolver.new(club_updates)
      Turn::Engines::ClubMatchDayIncome.new(week, resolver).process

      expect(Club.first.bank_bal).to eq(0)
    end
  end

  describe 'fan_happiness_match' do
    it 'adjust fan happiness depending on the match result (win for club 1)' do
      create(:club,
             id: 1,
             fan_happiness: 50)
      create(:club,
             id: 2,
             fan_happiness: 50)
      create(:match, home_goals: 3, away_goals: 1)

      Turn::Engines::ClubFanHappinessMatch.new(week).process

      expect(Club.first.fan_happiness).to eq(59)
      expect(Club.last.fan_happiness).to eq(45)
    end

    it 'adjust fan happiness depending on the match result (win for club 2)' do
      create(:club,
             id: 1,
             fan_happiness: 50)
      create(:club,
             id: 2,
             fan_happiness: 50)
      create(:match, home_goals: 3, away_goals: 4)

      Turn::Engines::ClubFanHappinessMatch.new(week).process

      expect(Club.first.fan_happiness).to eq(45)
      expect(Club.last.fan_happiness).to eq(59)
    end

    it 'adjust fan happiness depending on the match result (draw)' do
      create(:club,
             id: 1,
             fan_happiness: 50)
      create(:club,
             id: 2,
             fan_happiness: 50)

      create(:match, home_goals: 3, away_goals: 3)

      Turn::Engines::ClubFanHappinessMatch.new(week).process

      expect(Club.first.fan_happiness).to eq(53)
      expect(Club.last.fan_happiness).to eq(53)
    end
  end

  describe 'fan_happiness_signings' do
    it 'adjust fan happiness if a player is signed' do
      create(:club,
             id: 2,
             fan_happiness: 50)

      create(:transfer, player_id: 1, status: 'completed', week: 1)

      Turn::Engines::ClubFanHappinessSignings.new(week).process

      expect(Club.first.fan_happiness).to eq(56)
    end
  end

  describe 'fan_happiness_bank' do
    it 'adjust fan happiness up by 3 as the club is rich' do
      create(:club,
             id: 2,
             bank_bal: 100_000_000,
             fan_happiness: 50)

      club = Club.first

      Turn::Engines::ClubFanHappinessBank.new(week, club).process

      expect(Club.first.fan_happiness).to eq(53)
    end

    it 'adjust fan happiness down by 5 as the club is poor' do
      create(:club,
             id: 2,
             bank_bal: 1_000_000,
             fan_happiness: 50)

      club = Club.first

      Turn::Engines::ClubFanHappinessBank.new(week, club).process

      expect(Club.first.fan_happiness).to eq(45)
    end

    it 'no fan happiness change' do
      create(:club,
             id: 2,
             bank_bal: 50_000_000,
             fan_happiness: 50)
      club = Club.first

      Turn::Engines::ClubFanHappinessBank.new(week, club).process

      expect(Club.first.fan_happiness).to eq(50)
    end
  end

  describe 'fan_happiness_random' do
    it 'adjust fan happiness by a randoim amount and make sure it is 0 to 100' do
      create(:club,
             id: 2,
             fan_happiness: 50)

      club = Club.first

      allow_any_instance_of(Kernel).to receive(:rand).with(-3..3).and_return(1)

      Turn::Engines::ClubFanHappinessRandom.new(week, club).process

      expect(Club.first.fan_happiness).to eq(51)
    end

    it 'corrects a high amount to 100' do
      create(:club,
             id: 2,
             fan_happiness: 250)

      club = Club.first

      Turn::Engines::ClubFanHappinessRandom.new(week, club).process

      expect(Club.first.fan_happiness).to eq(100)
    end

    it 'corrects a minus amount to 0' do
      create(:club,
             id: 2,
             fan_happiness: -50)

      club = Club.first

      Turn::Engines::ClubFanHappinessRandom.new(week, club).process

      expect(Club.first.fan_happiness).to eq(0)
    end
  end

  describe 'overdrawn' do
    it 'should increase overdraft number to 3' do
      create(:club, id: 1, bank_bal: -600_000, overdrawn: 2, managed: true)
      create(:player, club_id: 1, wages: 100_000, value: 1_000_000)
      create(:player, club_id: 1, wages: 200_000, value: 1_000_000)
      create(:player, club_id: 1, wages: 300_000, value: 1_000_000)

      Turn::Engines::ClubOverdrawn.new(week).process

      expect(Club.first.bank_bal).to eq(-600_000)
      expect(Club.first.overdrawn).to eq(3)
    end

    it 'should fix the overdraft by selling a player' do
      create(:club, id: 1, bank_bal: -600_000, overdrawn: 4, managed: true)
      create(:club, id: 242, bank_bal: 0, overdrawn: 0)
      create(:player, name: 'a', club_id: 1, wages: 100_000, value: 1_000_000)
      create(:player, name: 'aa', club_id: 1, wages: 200_000, value: 1_000_000)
      create(:player, name: 'aaa', club_id: 1, wages: 300_000, value: 1_000_000)

      Turn::Engines::ClubFixOverdraft.new(week).process

      expect(Club.first.bank_bal).to eq(150_000)
      expect(Club.first.overdrawn).to eq(0)
      expect(Player.first.club_id).to eq(242)
      expect(Player.second.club_id).to eq(1)
      expect(Player.third.club_id).to eq(1)
    end

    it 'should sell 3 players and stop even though the overdraft will still exist' do
      create(:club, id: 1, bank_bal: -5_000_000, overdrawn: 4, managed: true)
      create(:club, id: 242, bank_bal: 0, overdrawn: 0)
      create(:player, name: 'a', club_id: 1, wages: 100_000, value: 1_000_000)
      create(:player, name: 'aa', club_id: 1, wages: 200_000, value: 1_000_000)
      create(:player, name: 'aaa', club_id: 1, wages: 300_000, value: 1_000_000)
      create(:player, name: 'aaaa', club_id: 1, wages: 300_000, value: 1_000_000)

      Turn::Engines::ClubFixOverdraft.new(week).process

      expect(Club.first.bank_bal).to eq(-2_750_000)
      expect(Club.first.overdrawn).to eq(4)
      expect(Player.first.club_id).to eq(242)
      expect(Player.second.club_id).to eq(242)
      expect(Player.third.club_id).to eq(242)
      expect(Player.fourth.club_id).to eq(1)
    end
  end
end
