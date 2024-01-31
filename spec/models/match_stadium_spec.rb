require 'rails_helper'
require 'pry'

RSpec.describe Match, type: :model do
  describe 'stadium_size calculation test' do
    it 'should return the total number of seats' do
      totals_with_blend = [{ team: '001' }]
      match = Match.new

      create(:club,
             stand_n_capacity: 1000,
             stand_s_capacity: 2000,
             stand_e_capacity: 3000,
             stand_w_capacity: 4000
            )

      stadium_size_answer = match.send(:stadium_size, totals_with_blend)

      expect(stadium_size_answer).to be == 10000
    end
  end

  describe 'stadium effect' do
    it 'should adjust the home totals based on stadium size' do
      match = Match.new
      home_stadium_size = 50_000
      totals_with_blend = [
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

      stadium_effect = match.send(:teams_with_stadium_effect, totals_with_blend, home_stadium_size)

      expect(stadium_effect[0][:defense]).to eq(205)
      expect(stadium_effect[0][:midfield]).to eq(155)
      expect(stadium_effect[0][:attack]).to eq(130)
      expect(stadium_effect[1][:defense]).to eq(100)
      expect(stadium_effect[1][:midfield]).to eq(100)
      expect(stadium_effect[1][:attack]).to eq(100)
    end
  end
end
