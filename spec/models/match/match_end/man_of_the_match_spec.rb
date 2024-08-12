RSpec.describe Match::ManOfTheMatch do
  describe 'with valid params' do
    let(:home_list) { [ 
                    { player_id: 401, match_performance: 50 },
                    { player_id: 402, match_performance: 40 } 
                    ] }
    let(:away_list) { [ 
                    { player_id: 501, match_performance: 60 },
                    { player_id: 502, match_performance: 30 }
                    ] }
    it 'selects the top performing player for home and away teams' do
      man_of_the_match = Match::ManOfTheMatch.new(home_list, away_list).call

      expect(man_of_the_match[:home_man_of_the_match]).to eq(401)
      expect(man_of_the_match[:away_man_of_the_match]).to eq(501)
    end
  end
end
