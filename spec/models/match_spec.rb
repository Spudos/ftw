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

  describe 'squad with tactics calculation' do
    before do
      @squad_with_performance = [
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'dfc',
          tactic: nil
        },
        {
          match_performance: 50,
          player_position_detail: 'l',
          player_position: 'mid',
          tactic: nil
        },
        {
          match_performance: 50,
          player_position_detail: 'r',
          player_position: 'att',
          tactic: nil
        }
      ]
    end

    [
      { tactic: 1, expected_results: [45, 65, 45] },
      { tactic: 2, expected_results: [65, 40, 40] },
      { tactic: 3, expected_results: [40, 55, 65] },
      { tactic: 4, expected_results: [40, 60, 60] },
      { tactic: 5, expected_results: [60, 40, 40] },
      { tactic: 6, expected_results: [55, 45, 55] },
      { tactic: nil, expected_results: [50, 50, 50] }
    ].each do |test_case|
      it "should return correct adjusted values for tactic #{test_case[:tactic]}" do
        @squad_with_performance.each { |player| player[:tactic] = test_case[:tactic] }

        adjusted_player = Match::TacticAdjustment.new(@squad_with_performance).player_performance_by_tactic

        test_case[:expected_results].each_with_index do |expected_result, index|
          expect(adjusted_player[index][:match_performance]).to be == expected_result
        end
      end
    end
  end

  describe 'star effect should amend the performance' do
    it 'should return the performance with star effect if triggered of 70, if not 50' do
      squads_with_tactics = [
        {
          match_performance: 50,
          star: 20
        }
      ]
      adjusted_player = Match::StarEffect.new(squads_with_tactics).star_effect

      expect(adjusted_player[0][:match_performance]).to eq(50).or eq(70)
    end
    it 'should return the performance of 20 to 30' do
      squads_with_tactics = [
        {
          match_performance: 10,
          star: 0
        }
      ]
      adjusted_player = Match::StarEffect.new(squads_with_tactics).star_effect

      expect(adjusted_player[0][:match_performance]).to be_between(20, 30).inclusive
    end
  end
end
