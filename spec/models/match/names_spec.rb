require 'rails_helper'
require 'pry'

RSpec.describe Match::Names, type: :model do
  describe 'select assist and scorer' do
    let(:goal_scored) { { goal_scored: 'home' } }

    it 'should return home assist and scorer and they should be different' do
      home_top = [
        { match_performance: 50, player_position: 'dfc', club_id: 1, player_id: 402 },
        { match_performance: 55, player_position: 'mid', club_id: 1, player_id: 403 },
        { match_performance: 60, player_position: 'att', club_id: 1, player_id: 404 },
        { match_performance: 65, player_position: 'att', club_id: 1, player_id: 405 },
        { match_performance: 70, player_position: 'att', club_id: 1, player_id: 406 },
      ]

      away_top = [
        { match_performance: 50, player_position: 'dfc', club_id: 2, player_id: 502 },
        { match_performance: 30, player_position: 'mid', club_id: 2, player_id: 503 },
        { match_performance: 35, player_position: 'mid', club_id: 2, player_id: 504 },
        { match_performance: 40, player_position: 'att', club_id: 2, player_id: 505 },
        { match_performance: 45, player_position: 'att', club_id: 2, player_id: 506 },
      ]

      assist, scorer = Match::Names.new(goal_scored, home_top, away_top).call

      expect(home_top.map { |player| player[:player_id] }).to include(assist[:assist])
      expect(home_top.map { |player| player[:player_id] }).to include(scorer[:scorer])
      expect(assist[:assist]).to_not eq(scorer[:scorer])
    end
  end

  describe 'select assist and scorer' do
    let(:goal_scored) { { goal_scored: 'away' } }

    it 'should return away assist and scorer and they should be different' do
      home_top = [
        { match_performance: 50, player_position: 'dfc', club_id: 1, player_id: 402 },
        { match_performance: 55, player_position: 'mid', club_id: 1, player_id: 403 },
        { match_performance: 60, player_position: 'att', club_id: 1, player_id: 404 },
        { match_performance: 65, player_position: 'att', club_id: 1, player_id: 405 },
        { match_performance: 70, player_position: 'att', club_id: 1, player_id: 406 },
      ]

      away_top = [
        { match_performance: 50, player_position: 'dfc', club_id: 2, player_id: 502 },
        { match_performance: 30, player_position: 'mid', club_id: 2, player_id: 503 },
        { match_performance: 35, player_position: 'mid', club_id: 2, player_id: 504 },
        { match_performance: 40, player_position: 'att', club_id: 2, player_id: 505 },
        { match_performance: 45, player_position: 'att', club_id: 2, player_id: 506 },
      ]

      assist, scorer = Match::Names.new(goal_scored, home_top, away_top).call

      expect(away_top.map { |player| player[:player_id] }).to include(assist[:assist])
      expect(away_top.map { |player| player[:player_id] }).to include(scorer[:scorer])
      expect(assist[:assist]).to_not eq(scorer[:scorer])
    end
  end

  describe 'select assist and scorer' do
    let(:goal_scored) { { goal_scored: 'none' } }

    it 'should return no assist and scorer' do
      home_top = [
        { match_performance: 50, player_position: 'dfc', club_id: 1, player_id: 402 },
        { match_performance: 55, player_position: 'mid', club_id: 1, player_id: 403 },
        { match_performance: 60, player_position: 'att', club_id: 1, player_id: 404 },
        { match_performance: 65, player_position: 'att', club_id: 1, player_id: 405 },
        { match_performance: 70, player_position: 'att', club_id: 1, player_id: 406 },
      ]

      away_top = [
        { match_performance: 50, player_position: 'dfc', club_id: 2, player_id: 502 },
        { match_performance: 30, player_position: 'mid', club_id: 2, player_id: 503 },
        { match_performance: 35, player_position: 'mid', club_id: 2, player_id: 504 },
        { match_performance: 40, player_position: 'att', club_id: 2, player_id: 505 },
        { match_performance: 45, player_position: 'att', club_id: 2, player_id: 506 },
      ]

      assist, scorer = Match::Names.new(goal_scored, home_top, away_top).call

      expect(assist[:assist]).to eq('none')
      expect(scorer[:scorer]).to eq('none')
    end
  end
end
