require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializeMatch::GetTactic, type: :model do
  describe 'call' do
    it 'when tactics exist returns valid tactics' do
      create(:tactic, club_id: 1)
      create(:tactic, club_id: 2)

      fixture_list = [
        id: 1,
        club_home: '1',
        club_away: '2',
        week_number: 1,
        competition: 'Premier League'
      ]

      tactic = Match::InitializeMatch::GetTactic.new(fixture_list).call

      expect(tactic[0][:club_id]).to eq('1')
      expect(tactic[0][:tactic]).to eq(1)
      expect(tactic[0][:dfc_aggression]).to eq(6)
      expect(tactic[0][:mid_aggression]).to eq(6)
      expect(tactic[0][:att_aggression]).to eq(6)
      expect(tactic[0][:press]).to eq(6)
      expect(tactic[1][:club_id]).to eq('2')
      expect(tactic[1][:tactic]).to eq(1)
      expect(tactic[1][:dfc_aggression]).to eq(6)
      expect(tactic[1][:mid_aggression]).to eq(6)
      expect(tactic[1][:att_aggression]).to eq(6)
      expect(tactic[1][:press]).to eq(6)
    end

    it 'when valid tactics do not exist it returns standard tactics' do
      create(:tactic, club_id: 1)

      fixture_list = [
        id: 1,
        club_home: '1',
        club_away: '2',
        week_number: 1,
        competition: 'Premier League'
      ]

      tactic = Match::InitializeMatch::GetTactic.new(fixture_list).call

      expect(tactic[0][:club_id]).to eq('1')
      expect(tactic[0][:tactic]).to eq(1)
      expect(tactic[0][:dfc_aggression]).to eq(6)
      expect(tactic[0][:mid_aggression]).to eq(6)
      expect(tactic[0][:att_aggression]).to eq(6)
      expect(tactic[0][:press]).to eq(6)
      expect(tactic[1][:club_id]).to eq('2')
      expect(tactic[1][:tactic]).to eq(1)
      expect(tactic[1][:dfc_aggression]).to eq(0)
      expect(tactic[1][:mid_aggression]).to eq(0)
      expect(tactic[1][:att_aggression]).to eq(0)
      expect(tactic[1][:press]).to eq(0)
    end
  end
end
