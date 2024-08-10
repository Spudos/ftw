require 'rails_helper'
require 'pry'

RSpec.describe Match::ChanceCreated, type: :model do
  describe 'decides if a home chance was created' do
    let(:team1) { { team: 001, defense: 200, midfield: 250, attack: 100 } }
    let(:team2) { { team: 002, defense: 250, midfield: 200, attack: 150 } }
    let(:final_team) { [team1, team2] }

    i = 1

    it 'return that the team created a chance based on midfield values' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(50)

      chance = Match::ChanceCreated.new(final_team, i).call

      expect(chance[:minute]).to eq(1)
      expect(chance[:chance_outcome]).to eq('home')
    end

    it 'return that the team created a random chance' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(50)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(3)

      chance = Match::ChanceCreated.new(final_team, i).call

      expect(chance[:minute]).to eq(1)
      expect(chance[:chance_outcome]).to eq('home')
    end

    it 'return that no team created a chance' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(50)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(50)

      chance = Match::ChanceCreated.new(final_team, i).call

      expect(chance[:minute]).to eq(1)
      expect(chance[:chance_outcome]).to eq('none')
    end
  end

  describe 'decides if a away chance was created' do
    let(:team1) { { team: 001, defense: 200, midfield: 150, attack: 100 } }
    let(:team2) { { team: 002, defense: 250, midfield: 200, attack: 150 } }
    let(:final_team) { [team1, team2] }

    i = 1

    it 'return that the team created a chance based on midfield values' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(50)

      chance = Match::ChanceCreated.new(final_team, i).call

      expect(chance[:minute]).to eq(1)
      expect(chance[:chance_outcome]).to eq('away')
    end

    it 'return that the team created a random chance' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(50)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(7)

      chance = Match::ChanceCreated.new(final_team, i).call

      expect(chance[:minute]).to eq(1)
      expect(chance[:chance_outcome]).to eq('away')
    end
  end
end