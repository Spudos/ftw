require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinutePress, type: :model do
  describe 'calculate match_squad totals with positive press values' do
    it 'based on a press of 1 for the home side and 2 for the away side in the 9th minute' do
      i = 9

      selection_complete = [{ club_id: '1', player_id: 1, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 2, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '3', player_id: 3, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '4', player_id: 4, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '5', player_id: 5, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '6', player_id: 6, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 10 },
                { club_id: '2', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 6 },
                { club_id: '3', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 3 },
                { club_id: '4', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 0 },
                { club_id: '5', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: -5 },
                { club_id: '6', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: -8 }]

      minute_by_minute_press = Match::MinuteByMinute::MinuteByMinutePress.new(selection_complete, tactic, i).call

      expect(minute_by_minute_press[0][:performance]).to eq(80)
      expect(minute_by_minute_press[1][:performance]).to eq(68)
      expect(minute_by_minute_press[2][:performance]).to eq(59)
      expect(minute_by_minute_press[3][:performance]).to eq(50)
      expect(minute_by_minute_press[4][:performance]).to eq(35)
      expect(minute_by_minute_press[5][:performance]).to eq(26)
    end

    it 'based on a press of 1 for the home side and 2 for the away side in the 49th minute' do
      i = 49

      selection_complete = [{ club_id: '1', player_id: 1, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 2, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '3', player_id: 3, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '4', player_id: 4, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '5', player_id: 5, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '6', player_id: 6, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 10 },
                { club_id: '2', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 6 },
                { club_id: '3', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 3 },
                { club_id: '4', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 0 },
                { club_id: '5', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: -5 },
                { club_id: '6', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: -8 }]

      minute_by_minute_press = Match::MinuteByMinute::MinuteByMinutePress.new(selection_complete, tactic, i).call

      expect(minute_by_minute_press[0][:performance]).to eq(40)
      expect(minute_by_minute_press[1][:performance]).to eq(44)
      expect(minute_by_minute_press[2][:performance]).to eq(47)
      expect(minute_by_minute_press[3][:performance]).to eq(50)
      expect(minute_by_minute_press[4][:performance]).to eq(55)
      expect(minute_by_minute_press[5][:performance]).to eq(58)
    end

    it 'based on a press of 1 for the home side and 2 for the away side in the 89th minute' do
      i = 89

      selection_complete = [{ club_id: '1', player_id: 1, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '2', player_id: 2, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '3', player_id: 3, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '4', player_id: 4, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '5', player_id: 5, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 },
                            { club_id: '6', player_id: 6, name: 'woolley',
                              total_skill: 85, position: 'gkp', position_detail: 'p',
                              blend: 5, star: 20, fitness: 90, performance: 50 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 10 },
                { club_id: '2', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 6 },
                { club_id: '3', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 3 },
                { club_id: '4', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 0 },
                { club_id: '5', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: -5 },
                { club_id: '6', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: -8 }]

      minute_by_minute_press = Match::MinuteByMinute::MinuteByMinutePress.new(selection_complete, tactic, i).call

      expect(minute_by_minute_press[0][:performance]).to eq(20)
      expect(minute_by_minute_press[1][:performance]).to eq(32)
      expect(minute_by_minute_press[2][:performance]).to eq(41)
      expect(minute_by_minute_press[3][:performance]).to eq(50)
      expect(minute_by_minute_press[4][:performance]).to eq(65)
      expect(minute_by_minute_press[5][:performance]).to eq(74)
    end
  end
end
