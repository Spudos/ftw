require 'rails_helper'
require 'pry'

RSpec.describe Match::CreateFixtures, type: :model do
  describe 'with valid params' do
    it 'returns a list of fixtures based on the provided params' do
      create(:fixture, week_number: 1, comp: 'Premier League')
      selected_week = 1
      competition = 'Premier League'

      fixture_list = Match::CreateFixtures.new(selected_week, competition).call

      expect(fixture_list).to contain_exactly(
        {
          id: 1,
          club_home: '1',
          club_away: '2',
          week_number: 1,
          competition: 'Premier League'
        }
      )
    end
  end
end
