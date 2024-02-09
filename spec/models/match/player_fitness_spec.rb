require 'rails_helper'
require 'pry'

RSpec.describe Match::PlayerFitness do
  describe '#call' do
    let(:squads_performance) { [{ player_id: 1, player_position: 'gkp' }, { player_id: 2, player_position: 'dfc' }] }
    let(:match_info) { { club_home: 'Home Club', dfc_aggression_home: 5, dfc_aggression_away: 5 } }

    it 'updates the fitness of players based on squads_performance and match_info' do
      allow_any_instance_of(Kernel).to receive(:rand).with(3..8).and_return(5)

      player1 = Player.create(id: 2, fitness: 90)

      Match::PlayerFitness.new(squads_performance, match_info).call

      expect(player1.reload.fitness).to eq(95)
    end
  end
end
