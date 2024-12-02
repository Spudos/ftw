require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinuteNames, type: :model do
  describe 'select assist and scorer' do
    let(:team1) { { club_id: '1', defense: 200, midfield: 250, attack: 100 } }
    let(:team2) { { club_id: '2', defense: 250, midfield: 200, attack: 150 } }
    let(:match_team) { [team1, team2] }

    it 'should return home assist and scorer and they should be different' do
      minute_by_minute_scored = { goal_home: 35,
                                  goal_away: 30,
                                  goal_roll: 20,
                                  goal_scored: 'home' }

      selection_complete = [{ club_id: '1', player_id: 1, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '1', player_id: 2, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 3, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 58 },
                            { club_id: '1', player_id: 4, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 53 },
                            { club_id: '1', player_id: 5, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 6, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 54 },
                            { club_id: '1', player_id: 7, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 56 },
                            { club_id: '1', player_id: 8, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 9, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 7, star: 20, fitness: 90, performance: 51 },
                            { club_id: '1', player_id: 10, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 53 },
                            { club_id: '1', player_id: 11, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 59 },
                            { club_id: '2', player_id: 12, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 10, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 13, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 52 },
                            { club_id: '2', player_id: 14, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 8, star: 20, fitness: 90, performance: 53 },
                            { club_id: '2', player_id: 15, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 54 },
                            { club_id: '2', player_id: 16, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 55 },
                            { club_id: '2', player_id: 17, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 2, star: 20, fitness: 90, performance: 56 },
                            { club_id: '2', player_id: 18, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 57 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 53 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 40 },
                            { club_id: '2', player_id: 20, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 30 },
                            { club_id: '2', player_id: 21, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 32 }]

      minute_by_minute_names = \
        Match::MinuteByMinute::MinuteByMinuteNames.new(minute_by_minute_scored, selection_complete, match_team).call

      expect(minute_by_minute_names[:scorer]).to be_truthy
      expect(minute_by_minute_names[:assist]).to be_truthy
      expect(minute_by_minute_names[:scorer]).not_to eq(minute_by_minute_names[:assist])
    end

    it 'should return away assist and scorer and they should be different' do
      minute_by_minute_scored = { goal_home: 35,
                                  goal_away: 30,
                                  goal_roll: 20,
                                  goal_scored: 'away' }

      selection_complete = [{ club_id: '1', player_id: 1, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '1', player_id: 2, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 3, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 58 },
                            { club_id: '1', player_id: 4, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 53 },
                            { club_id: '1', player_id: 5, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 6, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 54 },
                            { club_id: '1', player_id: 7, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 56 },
                            { club_id: '1', player_id: 8, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 9, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 7, star: 20, fitness: 90, performance: 51 },
                            { club_id: '1', player_id: 10, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 53 },
                            { club_id: '1', player_id: 11, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 59 },
                            { club_id: '2', player_id: 12, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 10, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 13, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 52 },
                            { club_id: '2', player_id: 14, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 8, star: 20, fitness: 90, performance: 53 },
                            { club_id: '2', player_id: 15, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 54 },
                            { club_id: '2', player_id: 16, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 55 },
                            { club_id: '2', player_id: 17, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 2, star: 20, fitness: 90, performance: 56 },
                            { club_id: '2', player_id: 18, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 57 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 53 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 40 },
                            { club_id: '2', player_id: 20, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 30 },
                            { club_id: '2', player_id: 21, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 32 }]

      minute_by_minute_names = \
        Match::MinuteByMinute::MinuteByMinuteNames.new(minute_by_minute_scored, selection_complete, match_team).call

      expect(minute_by_minute_names[:scorer]).to be_truthy
      expect(minute_by_minute_names[:assist]).to be_truthy
      expect(minute_by_minute_names[:scorer]).not_to eq(minute_by_minute_names[:assist])
    end

    it 'should return no assist and scorer' do
      minute_by_minute_scored = { goal_home: 35,
                                  goal_away: 30,
                                  goal_roll: 80,
                                  goal_scored: 'none' }

      selection_complete = [{ club_id: '1', player_id: 1, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '1', player_id: 2, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 3, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 58 },
                            { club_id: '1', player_id: 4, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 53 },
                            { club_id: '1', player_id: 5, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 6, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 54 },
                            { club_id: '1', player_id: 7, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 56 },
                            { club_id: '1', player_id: 8, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 52 },
                            { club_id: '1', player_id: 9, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 7, star: 20, fitness: 90, performance: 51 },
                            { club_id: '1', player_id: 10, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 53 },
                            { club_id: '1', player_id: 11, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 59 },
                            { club_id: '2', player_id: 12, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 10, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 13, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 52 },
                            { club_id: '2', player_id: 14, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 8, star: 20, fitness: 90, performance: 53 },
                            { club_id: '2', player_id: 15, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 54 },
                            { club_id: '2', player_id: 16, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 55 },
                            { club_id: '2', player_id: 17, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 2, star: 20, fitness: 90, performance: 56 },
                            { club_id: '2', player_id: 18, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 57 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 53 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 40 },
                            { club_id: '2', player_id: 20, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 30 },
                            { club_id: '2', player_id: 21, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 32 }]

      minute_by_minute_names = \
        Match::MinuteByMinute::MinuteByMinuteNames.new(minute_by_minute_scored, selection_complete, match_team).call

      expect(minute_by_minute_names[:scorer]).to eq('none')
      expect(minute_by_minute_names[:assist]).to eq('none')
    end
  end
end
