require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializePlayer::SelectionPerformance, type: :model do
  describe 'build the player array' do
    it 'should return the correct information' do
      create(:club, id: 1)
      create(:player, id: 418, club_id: 1)
      create(:player, id: 419, club_id: 1)
      selections = [{ club_id: '1', player_id: 418 },
                    { club_id: '1', player_id: 419 }]

      selection_performance = Match::InitializePlayer::SelectionPerformance.new(selections).call

      expect(selection_performance[0][:club_id]).to eq('1')
      expect(selection_performance[0][:player_id]).to eq(418)
      expect(selection_performance[0][:name]).to eq('Woolley')
      expect(selection_performance[0][:total_skill]).to eq(85)
      expect(selection_performance[0][:position]).to eq('gkp')
      expect(selection_performance[0][:position_detail]).to eq('p')
      expect(selection_performance[0][:blend]).to eq(5)
      expect(selection_performance[0][:star]).to eq(5)
      expect(selection_performance[0][:fitness]).to eq(90)
      expect(selection_performance[0][:performance]).to be_between(0, 200).inclusive
    end
  end
end
