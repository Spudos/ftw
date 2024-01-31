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

        adjusted_player = Match::TacticAdjustment.new(@squad_with_performance).player_performance_by_tactic

        test_case[:expected_results].each_with_index do |expected_result, index|
          expect(adjusted_player[index][:match_performance]).to be == expected_result
        end
      end
    end
  end

  describe 'star effect should amend the performance' do
    it 'should return the performance with star effect of 70' do
      allow_any_instance_of(Kernel).to receive(:rand).with(100).and_return(51)
      squads_with_tactics = [
        {
          match_performance: 50,
          star: 20
        }
      ]
      adjusted_player = Match::StarEffect.new(squads_with_tactics).star_effect

      expect(adjusted_player[0][:match_performance]).to eq(70)
    end
    it 'should return the performance without star effect of 50' do
      allow_any_instance_of(Kernel).to receive(:rand).with(100).and_return(49)
      squads_with_tactics = [
        {
          match_performance: 50,
          star: 20
        }
      ]
      adjusted_player = Match::StarEffect.new(squads_with_tactics).star_effect

      expect(adjusted_player[0][:match_performance]).to eq(50)
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

  describe 'team totals' do
    it 'should return the total performance for each area of the team' do
      final_squad_totals = [
        {
          match_performance: 50,
          player_position: 'gkp',
          club: '001',
          player_blend: 5
        },
        {
          match_performance: 50,
          player_position: 'dfc',
          club: '001',
          player_blend: 15
        },
        {
          match_performance: 50,
          player_position: 'mid',
          club: '001',
          player_blend: 5
        },
        {
          match_performance: 50,
          player_position: 'att',
          club: '001',
          player_blend: 5
        },
        {
          match_performance: 40,
          player_position: 'gkp',
          club: '002',
          player_blend: 4
        },
        {
          match_performance: 40,
          player_position: 'dfc',
          club: '002',
          player_blend: 10
        },
        {
          match_performance: 40,
          player_position: 'mid',
          club: '002',
          player_blend: 8
        },
        {
          match_performance: 40,
          player_position: 'mid',
          club: '002',
          player_blend: 4
        },
        {
          match_performance: 40,
          player_position: 'att',
          club: '002',
          player_blend: 6
        },
        {
          match_performance: 40,
          player_position: 'att',
          club: '002',
          player_blend: 4
        }
      ]
      totals = Match::TeamTotals.new(final_squad_totals).team_totals

      expect(totals[0][:team]).to eq('001')
      expect(totals[0][:defense]).to eq(100)
      expect(totals[0][:defense_blend]).to eq(10)
      expect(totals[0][:midfield]).to eq(50)
      expect(totals[0][:midfield_blend]).to eq(0)
      expect(totals[0][:attack]).to eq(50)
      expect(totals[0][:attack_blend]).to eq(0)
      expect(totals[1][:team]).to eq('002')
      expect(totals[1][:defense]).to eq(80)
      expect(totals[1][:defense_blend]).to eq(6)
      expect(totals[1][:midfield]).to eq(80)
      expect(totals[1][:midfield_blend]).to eq(4)
      expect(totals[1][:attack]).to eq(80)
      expect(totals[1][:attack_blend]).to eq(2)
    end
  end

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

      totals_with_blend, blend_totals = Match::Blends.new(totals).team_blend

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
