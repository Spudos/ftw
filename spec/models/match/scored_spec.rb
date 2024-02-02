require 'rails_helper'
require 'pry'

RSpec.describe Match::Scored, type: :model do
  describe 'selects the home player that scored' do
    let(:player1) { { player_id: 401, player_position: "dfc", match_performance: 50 } }
    let(:player2) { { player_id: 402, player_position: "mid", match_performance: 50 } }
    let(:player3) { { player_id: 403, player_position: "mid", match_performance: 50 } }
    let(:player4) { { player_id: 404, player_position: "att", match_performance: 50 } }
    let(:player5) { { player_id: 405, player_position: "att", match_performance: 50 } }
    let(:player6) { { player_id: 501, player_position: "att", match_performance: 50 } }
    let(:player7) { { player_id: 502, player_position: "att", match_performance: 50 } }
    let(:player8) { { player_id: 503, player_position: "att", match_performance: 50 } }
    let(:player9) { { player_id: 504, player_position: "att", match_performance: 50 } }
    let(:player10) { { player_id: 505, player_position: "att", match_performance: 50 } }

    let(:home_top) { [player1, player2, player3, player4, player5] }
    let(:away_top) { [player6, player7, player8, player9, player10] }
    let(:assist) { { player_id: 401 } }
    let(:goal_scored) { { goal_scored: 'home' } }

    it 'that is different to the home assist' do
      scorer = Match::Scored.new(home_top, away_top, assist, goal_scored).call

      expect(home_top.map { |player| player[:player_id] }).to include(scorer[:scorer])
      expect(assist[:assist]).to_not eq(scorer[:scorer])
    end
  end

  describe 'selects the away player that scored' do
    let(:player1) { { player_id: 401, player_position: "dfc", match_performance: 50 } }
    let(:player2) { { player_id: 402, player_position: "mid", match_performance: 50 } }
    let(:player3) { { player_id: 403, player_position: "mid", match_performance: 50 } }
    let(:player4) { { player_id: 404, player_position: "att", match_performance: 50 } }
    let(:player5) { { player_id: 405, player_position: "att", match_performance: 50 } }
    let(:player6) { { player_id: 501, player_position: "att", match_performance: 50 } }
    let(:player7) { { player_id: 502, player_position: "att", match_performance: 50 } }
    let(:player8) { { player_id: 503, player_position: "att", match_performance: 50 } }
    let(:player9) { { player_id: 504, player_position: "att", match_performance: 50 } }
    let(:player10) { { player_id: 505, player_position: "att", match_performance: 50 } }

    let(:home_top) { [player1, player2, player3, player4, player5] }
    let(:away_top) { [player6, player7, player8, player9, player10] }
    let(:assist) { { player_id: 501 } }
    let(:goal_scored) { { goal_scored: 'away' } }

    it 'that is different to the away assist' do
      scorer = Match::Scored.new(home_top, away_top, assist, goal_scored).call

      expect(away_top.map { |player| player[:player_id] }).to include(scorer[:scorer])
      expect(assist[:assist]).to_not eq(scorer[:scorer])
    end
  end
end