require 'rails_helper'
require 'pry'

RSpec.describe Match::StadiumSize, type: :model do
  describe 'stadium_size calculation test' do
    it 'should return the total number of seats' do
      totals_blend = [{ team: '001' }]

      create(:club,
             stand_n_capacity: 1000,
             stand_s_capacity: 2000,
             stand_e_capacity: 3000,
             stand_w_capacity: 4000
            )

      stadium_size_answer = Match::StadiumSize.new(totals_blend).call

      expect(stadium_size_answer).to be == 10000
    end
  end

end
