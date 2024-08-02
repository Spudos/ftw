require 'rails_helper'
require 'pry'

RSpec.describe Match::StadiumSize, type: :model do
  describe 'stadium_size calculation test' do
    it 'should return the total number of seats' do
      totals_blend = [{ team: 1 }]

      create(:club,
             stand_n_capacity: 1000,
             stand_s_capacity: 2000,
             stand_e_capacity: 3000,
             stand_w_capacity: 4000,
             fanbase: 100_000)

      allow_any_instance_of(Kernel).to receive(:rand).with(0.9756..0.9923).and_return(0.99)

      stadium_size_answer = Match::StadiumSize.new(totals_blend).call

      expect(stadium_size_answer).to be == 9_900
    end
  end
end
