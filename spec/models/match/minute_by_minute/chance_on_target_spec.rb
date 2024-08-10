require 'rails_helper'
require 'pry'

RSpec.describe Match::ChanceOnTarget, type: :model do
  describe 'decides if a home chance was on target' do
    let(:team1) { { team: 001, defense: 200, midfield: 250, attack: 100 } }
    let(:team2) { { team: 002, defense: 250, midfield: 200, attack: 150 } }
    let(:final_team) { [team1, team2] }

    chance_result = { minute: 1, chance_outcome: 'home' }

    it 'return that the chance was on target' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)

      chance = Match::ChanceOnTarget.new(chance_result, final_team).call

      expect(chance[:chance_on_target]).to eq('home')
    end

    it 'return that the chance was not on target' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(90)

      chance = Match::ChanceOnTarget.new(chance_result, final_team).call

      expect(chance[:chance_on_target]).to eq('none')
    end
  end

  describe 'decides if a away chance was on target' do
    let(:team1) { { team: 001, defense: 200, midfield: 250, attack: 100 } }
    let(:team2) { { team: 002, defense: 250, midfield: 200, attack: 150 } }
    let(:final_team) { [team1, team2] }

    chance_result = { minute: 1, chance_outcome: 'away' }

    it 'return that the chance was on target' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)

      chance = Match::ChanceOnTarget.new(chance_result, final_team).call

      expect(chance[:chance_on_target]).to eq('away')
    end

    it 'return that the chance was not on target' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(90)

      chance = Match::ChanceOnTarget.new(chance_result, final_team).call

      expect(chance[:chance_on_target]).to eq('none')
    end
  end
end
