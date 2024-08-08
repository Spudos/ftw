require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializeMatch::GetTactics, type: :model do
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

      tactics = Match::InitializeMatch::GetTactics.new(fixture_list).call

      expect(tactics[0]).to contain_exactly(club_id: '1',
                                            tactics: 1,
                                            dfc_aggression: 6,
                                            mid_aggression: 6,
                                            att_aggression: 6,
                                            press: 6)
      expect(tactics[1]).to contain_exactly(club_id: '2',
                                            tactics: 1,
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

      tactics = Match::InitializeMatch::GetTactics.new(fixture_list).call

      expect(tactics[0]).to contain_exactly(club_id: '1',
                                            tactics: 1,
                                            dfc_aggression: 6,
                                            mid_aggression: 6,
                                            att_aggression: 6,
                                            press: 6)
      expect(tactics[1]).to contain_exactly(club_id: '2',
                                            tactics: 1,
                                            dfc_aggression: 0,
                                            mid_aggression: 0,
                                            att_aggression: 0,
                                            press: 0)
    end
  end
end
