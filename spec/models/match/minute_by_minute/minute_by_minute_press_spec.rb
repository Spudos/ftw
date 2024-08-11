require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinutePress, type: :model do
  describe 'calculate match_squad totals with positive press values' do
    it 'based on a press of 1 for the home side and 2 for the away side in the 9th minute' do
      i = 9

      all_teams = [{ team: '1', defense: 200, midfield: 200, attack: 100 },
                   { team: '2', defense: 200, midfield: 200, attack: 100 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 10 },
                { club_id: '2', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 6 }]

      minute_by_minute_press = Match::MinuteByMinute::MinuteByMinutePress.new(all_teams, tactic, i).call

      expect(minute_by_minute_press[0][:defense]).to eq(200)
      expect(minute_by_minute_press[0][:midfield]).to eq(260)
      expect(minute_by_minute_press[0][:attack]).to eq(160)
      expect(minute_by_minute_press[1][:defense]).to eq(200)
      expect(minute_by_minute_press[1][:midfield]).to eq(236)
      expect(minute_by_minute_press[1][:attack]).to eq(136)
    end

    it 'based on a press of 3 for the home side and 4 for the away side in the 49th minute' do
      i = 49

      all_teams = [{ team: '1', defense: 200, midfield: 200, attack: 100 },
                   { team: '2', defense: 200, midfield: 200, attack: 100 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 3 },
                { club_id: '2', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: 0 }]

      minute_by_minute_press = Match::MinuteByMinute::MinuteByMinutePress.new(all_teams, tactic, i).call

      expect(minute_by_minute_press[0][:defense]).to eq(200)
      expect(minute_by_minute_press[0][:midfield]).to eq(206)
      expect(minute_by_minute_press[0][:attack]).to eq(106)
      expect(minute_by_minute_press[1][:defense]).to eq(200)
      expect(minute_by_minute_press[1][:midfield]).to eq(200)
      expect(minute_by_minute_press[1][:attack]).to eq(100)
    end

    it 'based on a press of 5 for the home side and 6 for the away side in the 89th minute' do
      i = 89

      all_teams = [{ team: '1', defense: 200, midfield: 200, attack: 100 },
                   { team: '2', defense: 200, midfield: 200, attack: 100 }]

      tactic = [{ club_id: '1', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: -5 },
                { club_id: '2', tactic: 1, dfc_aggression: 2, mid_aggression: 4, att_aggression: 6, press: -8 }]

      minute_by_minute_press = Match::MinuteByMinute::MinuteByMinutePress.new(all_teams, tactic, i).call

      expect(minute_by_minute_press[0][:defense]).to eq(200)
      expect(minute_by_minute_press[0][:midfield]).to eq(220)
      expect(minute_by_minute_press[0][:attack]).to eq(120)
      expect(minute_by_minute_press[1][:defense]).to eq(200)
      expect(minute_by_minute_press[1][:midfield]).to eq(232)
      expect(minute_by_minute_press[1][:attack]).to eq(132)
    end
  end
end
