require 'rails_helper'
require 'pry'

RSpec.describe Match::TeamTotals, type: :model do
  describe 'team totals' do
    it 'should return the total performance for each area of the team' do
      final_squad = [
        {
          match_performance: 50,
          player_position: 'gkp',
          club_id: 1,
          player_blend: 5
        },
        {
          match_performance: 50,
          player_position: 'dfc',
          club_id: 1,
          player_blend: 15
        },
        {
          match_performance: 50,
          player_position: 'mid',
          club_id: 1,
          player_blend: 5
        },
        {
          match_performance: 50,
          player_position: 'att',
          club_id: 1,
          player_blend: 5
        },
        {
          match_performance: 40,
          player_position: 'gkp',
          club_id: 2,
          player_blend: 4
        },
        {
          match_performance: 40,
          player_position: 'dfc',
          club_id: 2,
          player_blend: 10
        },
        {
          match_performance: 40,
          player_position: 'mid',
          club_id: 2,
          player_blend: 8
        },
        {
          match_performance: 40,
          player_position: 'mid',
          club_id: 2,
          player_blend: 4
        },
        {
          match_performance: 40,
          player_position: 'att',
          club_id: 2,
          player_blend: 6
        },
        {
          match_performance: 40,
          player_position: 'att',
          club_id: 2,
          player_blend: 4
        }
      ]
      totals = Match::TeamTotals.new(final_squad).call

      expect(totals[0][:team]).to eq(1)
      expect(totals[0][:defense]).to eq(100)
      expect(totals[0][:defense_blend]).to eq(10)
      expect(totals[0][:midfield]).to eq(50)
      expect(totals[0][:midfield_blend]).to eq(0)
      expect(totals[0][:attack]).to eq(50)
      expect(totals[0][:attack_blend]).to eq(0)
      expect(totals[1][:team]).to eq(2)
      expect(totals[1][:defense]).to eq(80)
      expect(totals[1][:defense_blend]).to eq(6)
      expect(totals[1][:midfield]).to eq(80)
      expect(totals[1][:midfield_blend]).to eq(4)
      expect(totals[1][:attack]).to eq(80)
      expect(totals[1][:attack_blend]).to eq(2)
    end
  end
end
