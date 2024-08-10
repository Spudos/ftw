require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializePlayer::SelectionTactic, type: :model do
  describe 'squad with tactics calculation' do
    it 'should return adjusted values for tactic 1 and 2' do
      selection_performance = [{ club_id: '1', player_id: 1, name: 'woolley',
                                 total_skill: 85, position: 'gkp', position_detail: 'p',
                                 blend: 5, star: 20, fitness: 90, performance: 50 },
                               { club_id: '1', player_id: 1, name: 'woolley',
                                 total_skill: 85, position: 'dfc', position_detail: 'c',
                                 blend: 5, star: 20, fitness: 90, performance: 50 },
                               { club_id: '1', player_id: 1, name: 'woolley',
                                 total_skill: 85, position: 'mid', position_detail: 'c',
                                 blend: 5, star: 20, fitness: 90, performance: 50 },
                               { club_id: '1', player_id: 1, name: 'woolley',
                                 total_skill: 85, position: 'att', position_detail: 'c',
                                 blend: 5, star: 20, fitness: 90, performance: 50 },
                               { club_id: '2', player_id: 1, name: 'woolley',
                                 total_skill: 85, position: 'gkp', position_detail: 'p',
                                 blend: 5, star: 20, fitness: 90, performance: 50 },
                               { club_id: '2', player_id: 1, name: 'woolley',
                                 total_skill: 85, position: 'dfc', position_detail: 'c',
                                 blend: 5, star: 20, fitness: 90, performance: 50 },
                               { club_id: '2', player_id: 1, name: 'woolley',
                                 total_skill: 85, position: 'mid', position_detail: 'c',
                                 blend: 5, star: 20, fitness: 90, performance: 50 },
                               { club_id: '2', player_id: 1, name: 'woolley',
                                 total_skill: 85, position: 'att', position_detail: 'c',
                                 blend: 5, star: 20, fitness: 90, performance: 50 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 6,
                  mid_aggression: 6, att_aggression: 6, press: 6 },
                { club_id: '2', tactic: 2, dfc_aggression: 6,
                  mid_aggression: 6, att_aggression: 6, press: 6 }]

      selection_tactic = Match::InitializePlayer::SelectionTactic.new(selection_performance, tactic).call

      expect(selection_tactic[0][:performance]).to eq(50)
      expect(selection_tactic[1][:performance]).to eq(45)
      expect(selection_tactic[2][:performance]).to eq(65)
      expect(selection_tactic[3][:performance]).to eq(45)
      expect(selection_tactic[4][:performance]).to eq(50)
      expect(selection_tactic[5][:performance]).to eq(65)
      expect(selection_tactic[6][:performance]).to eq(40)
      expect(selection_tactic[7][:performance]).to eq(40)
    end

    it 'should return adjusted performance values for tactic 4 as it is a midl' do
      selection_performance = [{ club_id: '1',
                                 player_id: 1,
                                 name: 'woolley',
                                 total_skill: 85,
                                 position: 'mid',
                                 position_detail: 'l',
                                 blend: 5,
                                 star: 20,
                                 fitness: 90,
                                 performance: 50 }]

      tactic = [{ club_id: '1',
                  tactic: 4,
                  dfc_aggression: 6,
                  mid_aggression: 6,
                  att_aggression: 6,
                  press: 6 }]

      Match::InitializePlayer::SelectionTactic.new(selection_performance, tactic).call

      expect(selection_performance[0][:performance]).to eq(60)
    end

    it 'should return adjusted performance values for tactic 5 as it is a dfcc' do
      selection_performance = [{ club_id: '1',
                                 player_id: 1,
                                 name: 'woolley',
                                 total_skill: 85,
                                 position: 'dfc',
                                 position_detail: 'c',
                                 blend: 5,
                                 star: 20,
                                 fitness: 90,
                                 performance: 50 }]

      tactic = [{ club_id: '1',
                  tactic: 5,
                  dfc_aggression: 6,
                  mid_aggression: 6,
                  att_aggression: 6,
                  press: 6 }]

      Match::InitializePlayer::SelectionTactic.new(selection_performance, tactic).call

      expect(selection_performance[0][:performance]).to eq(60)
    end
  end
end
