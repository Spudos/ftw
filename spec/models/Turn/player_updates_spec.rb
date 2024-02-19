require 'rails_helper'
require 'pry'

RSpec.describe Turn::PlayerUpdates, type: :model do
  describe 'fitness increase' do
    let(:week) { 1 }

    it 'does not effect fitness' do
      create(:club, id: 1)
      create(:player, club_id: 1, fitness: 100)

      adjusted_player = Turn::PlayerUpdates.new(week).fitness_increase

      expect(adjusted_player[0][:fitness]).to eq(100)
    end

    it 'sets fitness to 100' do
      create(:club, id: 1)
      create(:player, club_id: 1, fitness: 110)

      adjusted_player = Turn::PlayerUpdates.new(week).fitness_increase

      expect(adjusted_player[0][:fitness]).to eq(100)
    end

    it 'increases the fitness by 3' do
      create(:club, id: 1)
      create(:player, club_id: 1, fitness: 0)
      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)

      adjusted_player = Turn::PlayerUpdates.new(week).fitness_increase

      expect(adjusted_player[0][:fitness]).to eq(3)
    end
  end

  describe 'contract_decrease' do
  let(:week) { 1 }

    it 'reduces the contract by 1' do
      create(:club, id: 1)
      create(:player, club_id: 1, contract: 20)
      adjusted_player = Turn::PlayerUpdates.new(week).contract_decrease

      expect(adjusted_player[0][:contract]).to eq(19)
    end

    it 'does not reduce the contract past 0' do
      create(:club, id: 1)
      create(:player, club_id: 1, contract: 0)

      adjusted_player = Turn::PlayerUpdates.new(week).contract_decrease

      expect(adjusted_player[0][:contract]).to eq(0)
    end

    it 'sets the contract to 0 as it was negative' do
      create(:club, id: 1)
      create(:player, club_id: 1, contract: -20)

      adjusted_player = Turn::PlayerUpdates.new(week).contract_decrease

      expect(adjusted_player[0][:contract]).to eq(0)
    end
  end

  describe 'player_value' do
    it 'calculates the correct player value' do
      create(:club, id: 1)
      create(:player, club_id: 1)
      week = 1

      Turn::PlayerUpdates.new(week).player_value

      player = Player.first

      expect(player.value).to eq(42929250)
    end
  end

  describe 'player_wage' do
    it 'calculates the correct player wage' do
      create(:club, id: 1)
      create(:player, club_id: 1)
      week = 1

      Turn::PlayerUpdates.new(week).player_wages

      player = Player.first

      expect(player.wages).to eq(172125)
    end
  end
end
