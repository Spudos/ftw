require 'rails_helper'
require 'pry'

RSpec.describe Match, type: :model do
  describe 'totals with blend' do
    it 'should return the total performance for each area of the team adjusted by that areas blend value' do
      totals = [
        {
          team: '001',
          defense: 200,
          defense_blend: 5,
          midfield: 150,
          midfield_blend: 5,
          attack: 100,
          attack_blend: 5
        },
        {
          team: '002',
          defense: 250,
          defense_blend: 2,
          midfield: 200,
          midfield_blend: 2,
          attack: 150,
          attack_blend: 2
        }
      ]

      totals_with_blend, blend_totals = Match::Blends.new(totals).run

      expect(totals_with_blend[0][:defense]).to eq(150)
      expect(totals_with_blend[0][:midfield]).to eq(112)
      expect(totals_with_blend[0][:attack]).to eq(75)
      expect(totals_with_blend[1][:defense]).to eq(225)
      expect(totals_with_blend[1][:midfield]).to eq(180)
      expect(totals_with_blend[1][:attack]).to eq(135)
      expect(blend_totals[0][:defense]).to eq(5)
      expect(blend_totals[0][:midfield]).to eq(5)
      expect(blend_totals[0][:attack]).to eq(5)
      expect(blend_totals[1][:defense]).to eq(2)
      expect(blend_totals[1][:midfield]).to eq(2)
      expect(blend_totals[1][:attack]).to eq(2)
    end
  end
end
