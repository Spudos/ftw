require 'rails_helper'
require 'pry'

RSpec.describe Match::StadiumEffect, type: :model do
  describe 'stadium effect' do
    it 'should adjust the home totals based on stadium size' do
      home_stadium_size = 50_000
      totals_blend = [
        {
          team: '001',
          defense: 200,
          midfield: 150,
          attack: 125
        },
        {
          team: '002',
          defense: 100,
          midfield: 100,
          attack: 100
        }
      ]

      stadium_effect = Match::StadiumEffect.new(totals_blend, home_stadium_size).call

      expect(stadium_effect[0][:defense]).to eq(205)
      expect(stadium_effect[0][:midfield]).to eq(155)
      expect(stadium_effect[0][:attack]).to eq(130)
      expect(stadium_effect[1][:defense]).to eq(100)
      expect(stadium_effect[1][:midfield]).to eq(100)
      expect(stadium_effect[1][:attack]).to eq(100)
    end
  end
end
