RSpec.describe Match::CreateFixtures do
  describe 'with valid params' do
    let(:params) { { selected_week: 1, competition: 'Premier League' } }
    it 'returns a list of fixtures based on the provided params' do
      create(:fixture, week_number: 1, comp: 'Premier League')

      fixture_list = Match::CreateFixtures.new(params).call

      expect(fixture_list).to contain_exactly(
        {
          id: 1,
          club_home: 1,
          club_away: 2,
          week_number: 1,
          competition: 'Premier League'
        }
      )
    end
  end
end