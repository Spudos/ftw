require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinuteBlend, type: :model do
  describe 'totals with blend' do
    it 'should return the total performance for each area of the team' do
      minute_by_minute_blend = [{ club_id: '1', player_id: 1, name: 'woolley',
                                  total_skill: 85, position: 'gkp', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 2, name: 'woolley',
                                  total_skill: 85, position: 'dfc', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 3, name: 'woolley',
                                  total_skill: 85, position: 'dfc', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 4, name: 'woolley',
                                  total_skill: 85, position: 'dfc', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 5, name: 'woolley',
                                  total_skill: 85, position: 'dfc', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 6, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 4, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 2, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 3, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 6, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 4, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 7, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 5, name: 'woolley',
                                  total_skill: 85, position: 'att', position_detail: 'p',
                                  blend: 1, star: 20, fitness: 90, performance: 50 },
                                { club_id: '1', player_id: 6, name: 'woolley',
                                  total_skill: 85, position: 'att', position_detail: 'p',
                                  blend: 9, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 7, name: 'woolley',
                                  total_skill: 85, position: 'gkp', position_detail: 'p',
                                  blend: 10, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 8, name: 'woolley',
                                  total_skill: 85, position: 'dfc', position_detail: 'p',
                                  blend: 4, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 9, name: 'woolley',
                                  total_skill: 85, position: 'dfc', position_detail: 'p',
                                  blend: 8, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 10, name: 'woolley',
                                  total_skill: 85, position: 'dfc', position_detail: 'p',
                                  blend: 9, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 11, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 1, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 12, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 2, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 13, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 6, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 14, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 4, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 15, name: 'woolley',
                                  total_skill: 85, position: 'att', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 16, name: 'woolley',
                                  total_skill: 85, position: 'att', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '2', player_id: 17, name: 'woolley',
                                  total_skill: 85, position: 'att', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '3', player_id: 14, name: 'woolley',
                                  total_skill: 85, position: 'gkp', position_detail: 'p',
                                  blend: 4, star: 20, fitness: 90, performance: 50 },
                                { club_id: '3', player_id: 15, name: 'woolley',
                                  total_skill: 85, position: 'dfc', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '3', player_id: 16, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '3', player_id: 17, name: 'woolley',
                                  total_skill: 85, position: 'att', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '4', player_id: 14, name: 'woolley',
                                  total_skill: 85, position: 'gkp', position_detail: 'p',
                                  blend: 4, star: 20, fitness: 90, performance: 50 },
                                { club_id: '4', player_id: 15, name: 'woolley',
                                  total_skill: 85, position: 'dfc', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '4', player_id: 16, name: 'woolley',
                                  total_skill: 85, position: 'mid', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 },
                                { club_id: '4', player_id: 17, name: 'woolley',
                                  total_skill: 85, position: 'att', position_detail: 'p',
                                  blend: 5, star: 20, fitness: 90, performance: 50 }]

      fixture_attendance = [{ id: 1, club_home: '1', club_away: '2',
                              week_number: 1, competition: 'Premier League', attendance: 20_000 },
                            { id: 2, club_home: '3', club_away: '4',
                              week_number: 1, competition: 'Premier League', attendance: 20_000 }]

      all_teams = Match::MinuteByMinute::MinuteByMinuteTeams.new(minute_by_minute_blend, fixture_attendance).call

      expect(all_teams[0][0][:club_id]).to eq('1')
      expect(all_teams[0][0][:defence]).to eq(250)
      expect(all_teams[0][0][:midfield]).to eq(200)
      expect(all_teams[0][0][:attack]).to eq(100)
      expect(all_teams[0][1][:club_id]).to eq('2')
      expect(all_teams[0][1][:defence]).to eq(200)
      expect(all_teams[0][1][:midfield]).to eq(200)
      expect(all_teams[0][1][:attack]).to eq(150)
      expect(all_teams[1][0][:club_id]).to eq('3')
      expect(all_teams[1][0][:defence]).to eq(100)
      expect(all_teams[1][0][:midfield]).to eq(50)
      expect(all_teams[1][0][:attack]).to eq(50)
      expect(all_teams[1][1][:club_id]).to eq('4')
      expect(all_teams[1][1][:defence]).to eq(100)
      expect(all_teams[1][1][:midfield]).to eq(50)
      expect(all_teams[1][1][:attack]).to eq(50)
    end
  end
end
