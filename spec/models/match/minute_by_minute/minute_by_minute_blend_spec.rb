require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinuteBlend, type: :model do
  describe 'totals with blend' do
    it 'should return the total performance for each area of the team adjusted by that areas blend value' do
      selection_complete = [{ club_id: '1', player_id: 1, name: 'woolley',
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
                            { club_id: '1', player_id: 7, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '1', player_id: 8, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 50 },
                            { club_id: '1', player_id: 9, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 7, star: 20, fitness: 90, performance: 50 },
                            { club_id: '1', player_id: 10, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 50 },
                            { club_id: '1', player_id: 11, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 12, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 10, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 13, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 14, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 8, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 15, name: 'woolley',
                              total_skill: 85, position: 'dfc', position_detail: 'p',
                              blend: 9, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 16, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 1, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 17, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 2, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 18, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 6, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'mid', position_detail: 'p',
                              blend: 4, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 19, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 20, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 21, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 22, name: 'woolley',
                              total_skill: 85, position: 'att', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 }]

      minute_by_minute_blend = Match::MinuteByMinute::MinuteByMinuteBlend.new(selection_complete).call

      expect(minute_by_minute_blend[0][0][:performance]).to eq(60)
      expect(minute_by_minute_blend[0][1][:performance]).to eq(60)
      expect(minute_by_minute_blend[0][2][:performance]).to eq(60)
      expect(minute_by_minute_blend[0][3][:performance]).to eq(60)
      expect(minute_by_minute_blend[0][4][:performance]).to eq(60)
      expect(minute_by_minute_blend[0][5][:performance]).to eq(57)
      expect(minute_by_minute_blend[0][6][:performance]).to eq(57)
      expect(minute_by_minute_blend[0][7][:performance]).to eq(57)
      expect(minute_by_minute_blend[0][8][:performance]).to eq(57)
      expect(minute_by_minute_blend[0][9][:performance]).to eq(52)
      expect(minute_by_minute_blend[0][10][:performance]).to eq(52)
      expect(minute_by_minute_blend[0][11][:performance]).to eq(54)
      expect(minute_by_minute_blend[0][12][:performance]).to eq(54)
      expect(minute_by_minute_blend[0][13][:performance]).to eq(54)
      expect(minute_by_minute_blend[0][14][:performance]).to eq(54)
      expect(minute_by_minute_blend[0][15][:performance]).to eq(55)
      expect(minute_by_minute_blend[0][16][:performance]).to eq(55)
      expect(minute_by_minute_blend[0][17][:performance]).to eq(55)
      expect(minute_by_minute_blend[0][18][:performance]).to eq(55)
      expect(minute_by_minute_blend[0][19][:performance]).to eq(60)
      expect(minute_by_minute_blend[0][20][:performance]).to eq(60)
      expect(minute_by_minute_blend[0][21][:performance]).to eq(60)
      expect(minute_by_minute_blend[0][22][:performance]).to eq(60)
    end
  end
end
