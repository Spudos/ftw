require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializePlayer::SelectionAggression, type: :model do
  describe 'player perf with aggression' do
    it 'returns the totals with aggression' do
      selection_stadium = [{ club_id: '1', player_id: 1, name: 'woolley',
                             total_skill: 85, position: 'gkp', position_detail: 'p',
                             blend: 5, star: 20, fitness: 90, performance: 50 },
                           { club_id: '1', player_id: 2, name: 'woolley',
                             total_skill: 85, position: 'dfc', position_detail: 'p',
                             blend: 5, star: 20, fitness: 90, performance: 50 },
                           { club_id: '1', player_id: 3, name: 'woolley',
                             total_skill: 85, position: 'mid', position_detail: 'p',
                             blend: 5, star: 20, fitness: 90, performance: 50 },
                           { club_id: '1', player_id: 4, name: 'woolley',
                             total_skill: 85, position: 'att', position_detail: 'p',
                             blend: 5, star: 20, fitness: 90, performance: 50 },
                             { club_id: '2', player_id: 1, name: 'woolley',
                             total_skill: 85, position: 'gkp', position_detail: 'p',
                             blend: 5, star: 20, fitness: 90, performance: 50 },
                           { club_id: '2', player_id: 2, name: 'woolley',
                             total_skill: 85, position: 'dfc', position_detail: 'p',
                             blend: 5, star: 20, fitness: 90, performance: 50 },
                           { club_id: '2', player_id: 3, name: 'woolley',
                             total_skill: 85, position: 'mid', position_detail: 'p',
                             blend: 5, star: 20, fitness: 90, performance: 50 },
                           { club_id: '2', player_id: 4, name: 'woolley',
                             total_skill: 85, position: 'att', position_detail: 'p',
                             blend: 5, star: 20, fitness: 90, performance: 50 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 2,
                  mid_aggression: 4, att_aggression: 6, press: 6 },
                { club_id: '2', tactic: 1, dfc_aggression: 7,
                  mid_aggression: 5, att_aggression: 3, press: 6 }]

      selection_complete = Match::InitializePlayer::SelectionAggression.new(selection_stadium, tactic).call

      expect(selection_complete[0][:performance]).to eq(50)
      expect(selection_complete[1][:performance]).to eq(52)
      expect(selection_complete[2][:performance]).to eq(54)
      expect(selection_complete[3][:performance]).to eq(56)
      expect(selection_complete[4][:performance]).to eq(50)
      expect(selection_complete[5][:performance]).to eq(57)
      expect(selection_complete[6][:performance]).to eq(55)
      expect(selection_complete[7][:performance]).to eq(53)
    end
  end
end
