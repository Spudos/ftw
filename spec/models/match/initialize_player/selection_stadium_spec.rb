require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializePlayer::SelectionStadium, type: :model do
  describe 'stadium effect' do
    it 'should adjust the player totals based on attendance' do
      create(:club, id: 1, stand_n_capacity: 5000, stand_s_capacity: 5000,
                    stand_e_capacity: 5000, stand_w_capacity: 5000,
                    fan_happiness: 90, fanbase: 100_000)
      create(:club, id: 3, stand_n_capacity: 1000, stand_s_capacity: 1000,
                    stand_e_capacity: 1000, stand_w_capacity: 1000,
                    fan_happiness: 95, fanbase: 1000)
      create(:club, id: 5, stand_n_capacity: 20_000, stand_s_capacity: 20_000,
                    stand_e_capacity: 20_000, stand_w_capacity: 20_000,
                    fan_happiness: 100, fanbase: 100_000)

      selection_star = [{ club_id: '1', player_id: 1, name: 'woolley',
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

      fixture_list = [{ id: 1, club_home: '1', club_away: '2',
                        week_number: 1, competition: 'Premier League' },
                      { id: 2, club_home: '3', club_away: '4',
                        week_number: 1, competition: 'Premier League' },
                      { id: 3, club_home: '5', club_away: '6',
                        week_number: 1, competition: 'Premier League' }]

      allow_any_instance_of(Kernel).to receive(:rand).with(0.9756..0.9923).and_return(0.99)

      selection_stadium, fixture_list = Match::InitializePlayer::SelectionStadium.new(selection_star, fixture_list).call

      expect(fixture_list[0][:attendance]).to eq(19_800)
      expect(fixture_list[1][:attendance]).to eq(950)
      expect(fixture_list[2][:attendance]).to eq(79_200)
      expect(selection_stadium[0][:performance]).to eq(52)
      expect(selection_stadium[1][:performance]).to eq(50)
      expect(selection_stadium[2][:performance]).to eq(50)
      expect(selection_stadium[3][:performance]).to eq(50)
      expect(selection_stadium[4][:performance]).to eq(65)
      expect(selection_stadium[5][:performance]).to eq(50)
    end
  end
end
