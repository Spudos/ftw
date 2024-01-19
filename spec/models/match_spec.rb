require 'rails_helper'
require 'pry'

RSpec.describe Match, type: :model do
  describe 'stadium_size calculation test' do
    it "should return the total number of seats" do
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

  describe 'sqaud with tactics calculation' do
    it "should return correct adjusted values" do

      squad_with_performance = {
        match_performance: 50,
        player_position_detail: 'c',
        player_position: 'dfc',
        tactic: 1
      }

      match = Match.new

      adjusted_player = match.send(:player_performance_by_tactic, squad_with_performance)

      expect(adjusted_player.match_performance).to be == 45
    end
  end
end

