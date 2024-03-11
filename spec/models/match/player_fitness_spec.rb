require 'rails_helper'
require 'pry'

RSpec.describe Match::PlayerFitness do
  describe '#call' do
    let(:squads_performance) { [{ player_id: 1, player_position: 'gkp' }, { player_id: 2, player_position: 'dfc' }] }
    let(:match_info) { { club_home: 'Home Club', dfc_aggression_home: 5, dfc_aggression_away: 5 } }

    it 'updates the fitness of players based on squads_performance and match_info' do
      allow_any_instance_of(Kernel).to receive(:rand).with(3..8).and_return(5)

      Player.create!(id: 1, fitness: 90, club: build(:club))
      Player.create!(id: 2, fitness: 80, club: build(:club))

      Match::PlayerFitness.new(squads_performance, match_info).call

      player1 = Player.first
      player2 = Player.last

      expect(player1.fitness).to eq(80)
      expect(player2.fitness).to eq(70)
    end
  end
end
