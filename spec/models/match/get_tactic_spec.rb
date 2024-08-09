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
binding.pry
      expect(tactic[0]).to contain_exactly(club_id: '1',
                                           tactic: 1,
                                           dfc_aggression: 6,
                                           mid_aggression: 6,
                                           att_aggression: 6,
                                           press: 6)
      expect(tactic[1]).to contain_exactly(club_id: '2',
                                           tactic: 1,
                                           dfc_aggression: 6,
                                           mid_aggression: 6,
                                           att_aggression: 6,
                                           press: 6)
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

      expect(tactic[0]).to contain_exactly(club_id: '1',
                                           tactic: 1,
                                           dfc_aggression: 6,
                                           mid_aggression: 6,
                                           att_aggression: 6,
                                           press: 6)
      expect(tactic[1]).to contain_exactly(club_id: '2',
                                           tactic: 1,
                                           dfc_aggression: 0,
                                           mid_aggression: 0,
                                           att_aggression: 0,
                                           press: 0)
    end
  end
end
