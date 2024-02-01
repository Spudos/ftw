require 'rails_helper'
require 'pry'

RSpec.describe Match::Assisted, type: :model do
  describe 'selects the home player that assisted' do
    let(:player1) { { player_id: 401, player_position: "dfc", match_performance: 50 } }
    let(:player2) { { player_id: 402, player_position: "mid", match_performance: 50 } }
    let(:player3) { { player_id: 403, player_position: "mid", match_performance: 50 } }
    let(:player4) { { player_id: 404, player_position: "att", match_performance: 50 } }
    let(:player5) { { player_id: 405, player_position: "att", match_performance: 50 } }
    let(:player6) { { player_id: 406, player_position: "dfc", match_performance: 50 } }
    let(:player7) { { player_id: 407, player_position: "dfc", match_performance: 50 } }
    let(:player8) { { player_id: 408, player_position: "mid", match_performance: 50 } }
    let(:player9) { { player_id: 409, player_position: "att", match_performance: 50 } }
    let(:player10) { { player_id: 410, player_position: "att", match_performance: 50 } }

    let(:home_top) { [player1, player2, player3, player4, player5] }
    let(:away_top) { [player6, player7, player8, player9, player10] }

    let(:goal_scored) { { goal_scored: 'home' } }

    it 'returns the totals player assisted' do
      assist = Match::Assisted.new(home_top, away_top, goal_scored).call

      expect(home_top.map { |player| player[:player_id] }).to include(assist[:assist])
    end
  end

  describe 'selects the away player that assisted' do
    let(:player1) { { player_id: 401, player_position: "dfc", match_performance: 50 } }
    let(:player2) { { player_id: 402, player_position: "mid", match_performance: 50 } }
    let(:player3) { { player_id: 403, player_position: "mid", match_performance: 50 } }
    let(:player4) { { player_id: 404, player_position: "att", match_performance: 50 } }
    let(:player5) { { player_id: 405, player_position: "att", match_performance: 50 } }
    let(:player6) { { player_id: 406, player_position: "dfc", match_performance: 50 } }
    let(:player7) { { player_id: 407, player_position: "dfc", match_performance: 50 } }
    let(:player8) { { player_id: 408, player_position: "mid", match_performance: 50 } }
    let(:player9) { { player_id: 409, player_position: "att", match_performance: 50 } }
    let(:player10) { { player_id: 410, player_position: "att", match_performance: 50 } }

    let(:home_top) { [player1, player2, player3, player4, player5] }
    let(:away_top) { [player6, player7, player8, player9, player10] }

    let(:goal_scored) { { goal_scored: 'away' } }

    it 'returns the totals player assisted' do
      assist = Match::Assisted.new(home_top, away_top, goal_scored).call

      expect(away_top.map { |player| player[:player_id] }).to include(assist[:assist])
    end
  end
end