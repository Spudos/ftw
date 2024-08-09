require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializePlayer::SelectionFitness do
  describe '#call' do
    it 'updates the fitness of players based on squads_performance and match_info' do
      selection_star = [{ club_id: '1', player_id: 1, name: 'woolley',
                          total_skill: 85, position: 'gkp', position_detail: 'p',
                          blend: 5, star: 20, fitness: 90, performance: 50 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 6,
                  mid_aggression: 6, att_aggression: 6, press: 6 },
                { club_id: '2', tactic: 2, dfc_aggression: 6,
                  mid_aggression: 6, att_aggression: 6, press: 6 }]

      allow_any_instance_of(Kernel).to receive(:rand).with(3..8).and_return(5)

      selection_fitness = Match::InitializePlayer::SelectionFitness.new(selection_star, tactic).call

      expect(selection_fitness[0][:performance]).to eq(70)
    end
  end
end
