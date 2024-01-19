require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'stadium_size calculation test' do
    it "should return the number total number of seats" do
      totals_with_blend = [ team: '001' ]
      club = build(:club,
        stand_n_capacity: 1000,
        stand_s_capacity: 2000,
        stand_e_capacity: 3000,
        stand_w_capacity: 4000
      )

      stadium_size_answer = totals_with_blend.send(:stadium_size, totals_with_blend)

      expect(stadium_size_answer).to be == 10000
    end
  end
end
