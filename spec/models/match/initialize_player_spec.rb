require 'rails_helper'
require 'pry'

RSpec.describe Match, type: :model do
  describe 'call' do
    it 'initialize match and populate the 3 variables' do
      create(:club, id: 1)
      create(:player, id: 418, club_id: 1)
      create(:player, id: 419, club_id: 1, position: 'mid', player_position_detail: 'c')
      selection = [{ club_id: '1', player_id: 418 },
                   { club_id: '1', player_id: 419 }]
      tactic = [{ club_id: '1', tactics: 1, dfc_aggression: 6, mid_aggression: 6, att_aggression: 6, press: 6 }]

      selection_aggression = Match.new.send(:initialize_player, selection, tactic)

      expect(selection_aggression.size).to eq(2)
    end
  end
end
