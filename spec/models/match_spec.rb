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

      expect(stadium_size_answer).to be == 10_000
    end
  end

  describe 'sqaud with tactics calculation' do
    it 'should return correct adjusted values for tactic 1' do
      squad_with_performance = [
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'dfc',
          tactic: 1
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'mid',
          tactic: 1
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'att',
          tactic: 1
        }
      ]

      adjusted_player = Match::TacticAdjustment.new(squad_with_performance).player_performance_by_tactic
      expect(adjusted_player[0][:match_performance]).to be == 45
      expect(adjusted_player[1][:match_performance]).to be == 65
      expect(adjusted_player[2][:match_performance]).to be == 45
    end

    it 'should return correct adjusted values for tactic 2' do
      squad_with_performance = [
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'dfc',
          tactic: 2
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'mid',
          tactic: 2
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'att',
          tactic: 2
        }
      ]

      adjusted_player = Match::TacticAdjustment.new(squad_with_performance).player_performance_by_tactic
      expect(adjusted_player[0][:match_performance]).to be == 65
      expect(adjusted_player[1][:match_performance]).to be == 40
      expect(adjusted_player[2][:match_performance]).to be == 40
    end

    it 'should return correct adjusted values for tactic 3' do
      squad_with_performance = [
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'dfc',
          tactic: 3
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'mid',
          tactic: 3
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'att',
          tactic: 3
        }
      ]

      adjusted_player = Match::TacticAdjustment.new(squad_with_performance).player_performance_by_tactic
      expect(adjusted_player[0][:match_performance]).to be == 40
      expect(adjusted_player[1][:match_performance]).to be == 55
      expect(adjusted_player[2][:match_performance]).to be == 65
    end

    it 'should return correct adjusted values for tactic 4' do
      squad_with_performance = [
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'dfc',
          tactic: 4
        },
        {
          match_performance: 50,
          player_position_detail: 'l',
          player_position: 'mid',
          tactic: 4
        },
        {
          match_performance: 50,
          player_position_detail: 'r',
          player_position: 'att',
          tactic: 4
        }
      ]

      adjusted_player = Match::TacticAdjustment.new(squad_with_performance).player_performance_by_tactic
      expect(adjusted_player[0][:match_performance]).to be == 40
      expect(adjusted_player[1][:match_performance]).to be == 60
      expect(adjusted_player[2][:match_performance]).to be == 60
    end

    it 'should return correct adjusted values for tactic 5' do
      squad_with_performance = [
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'dfc',
          tactic: 5
        },
        {
          match_performance: 50,
          player_position_detail: 'l',
          player_position: 'mid',
          tactic: 5
        },
        {
          match_performance: 50,
          player_position_detail: 'r',
          player_position: 'att',
          tactic: 5
        }
      ]

      adjusted_player = Match::TacticAdjustment.new(squad_with_performance).player_performance_by_tactic
      expect(adjusted_player[0][:match_performance]).to be == 60
      expect(adjusted_player[1][:match_performance]).to be == 40
      expect(adjusted_player[2][:match_performance]).to be == 40
    end

    it 'should return correct adjusted values for tactic 6' do
      squad_with_performance = [
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'dfc',
          tactic: 6
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'mid',
          tactic: 6
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'att',
          tactic: 6
        }
      ]

      adjusted_player = Match::TacticAdjustment.new(squad_with_performance).player_performance_by_tactic
      expect(adjusted_player[0][:match_performance]).to be == 55
      expect(adjusted_player[1][:match_performance]).to be == 45
      expect(adjusted_player[2][:match_performance]).to be == 55
    end

    it 'should return original values for nil tactic' do
      squad_with_performance = [
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'dfc',
          tactic: nil
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'mid',
          tactic: nil
        },
        {
          match_performance: 50,
          player_position_detail: 'c',
          player_position: 'att',
          tactic: nil
        }
      ]

      adjusted_player = Match::TacticAdjustment.new(squad_with_performance).player_performance_by_tactic
      expect(adjusted_player[0][:match_performance]).to be == 50
      expect(adjusted_player[1][:match_performance]).to be == 50
      expect(adjusted_player[2][:match_performance]).to be == 50
    end
  end
end
