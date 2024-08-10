require 'rails_helper'
require 'pry'

RSpec.describe Match, type: :model do
  describe 'call' do
    it 'initialize match and populate the 3 variables' do
      create(:club, id: 1,
                    stand_n_capacity: 1000,
                    stand_s_capacity: 1000,
                    stand_e_capacity: 1000,
                    stand_w_capacity: 1000,
                    fan_happiness: 50,
                    fanbase: 1000)

      create(:player, id: 418, club_id: 1)
      create(:player, id: 419, club_id: 1, position: 'mid', player_position_detail: 'c')

      selection = [{ club_id: '1', player_id: 418 },
                   { club_id: '1', player_id: 419 }]

      tactic = [{ club_id: '1', tactics: 1, dfc_aggression: 6, mid_aggression: 6, att_aggression: 6, press: 6 }]

      fixture_list = [{ id: 1, club_home: '1', club_away: '2',
                        week_number: 1, competition: 'Premier League' }]

      selection_complete, fixture_list = Match.new.send(:initialize_player, selection, tactic, fixture_list)

      expect(fixture_list[0][:attendance]).to eq(500)
      expect(selection_complete[0][:performance]).to be > 20
      expect(selection_complete[1][:performance]).to be > 30
    end
  end
end
