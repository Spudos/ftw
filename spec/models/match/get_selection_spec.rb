require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializeMatch::GetSelection, type: :model do
  describe 'call' do
    it 'Selection exists so is added to variable' do
      create(:club, id: 1)

      (1..11).each do |player_id|
        Selection.create(player_id:, club_id: 1)
      end

      create(:club, id: 2)

      (12..22).each do |player_id|
        Selection.create(player_id:, club_id: 2)
      end

      fixture_list = [
        id: 1,
        club_home: '1',
        club_away: '2',
        week_number: 1,
        competition: 'Premier League'
      ]

      selection = Match::InitializeMatch::GetSelection.new(fixture_list).call

      expect(Selection.all.size).to eq(22)
      expect(selection[0][:club_id]).to eq('1')
      expect(selection[0][:player_id]).to eq(1)
      expect(selection[11][:club_id]).to eq('2')
      expect(selection[11][:player_id]).to eq(12)
    end
  end
end
