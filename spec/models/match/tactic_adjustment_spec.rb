require 'rails_helper'
require 'pry'

RSpec.describe Match, type: :model do
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

        adjusted_player = Match::TacticAdjustment.new(@squad_with_performance).call

        test_case[:expected_results].each_with_index do |expected_result, index|
          expect(adjusted_player[index][:match_performance]).to be == expected_result
        end
      end
    end
  end
end
