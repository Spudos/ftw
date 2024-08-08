require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializeMatch::GetFixtures, type: :model do
  describe 'with valid params' do
    it 'returns a list of fixtures based on the provided params' do
      create(:fixture)

      selected_week = 1
      competition = 'Premier League'

      fixture_list = Match::InitializeMatch::GetFixtures.new(selected_week, competition).call

      expect(fixture_list).to contain_exactly(id: 1,
                                              club_home: '1',
                                              club_away: '2',
                                              week_number: 1,
                                              competition: 'Premier League')
    end
  end
end
