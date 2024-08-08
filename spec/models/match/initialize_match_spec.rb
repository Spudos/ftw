require 'rails_helper'
require 'pry'

RSpec.describe Match, type: :model do
  describe 'call' do
    it 'initialize match and populate the 3 variables' do
      create(:fixture)
      create(:fixture, id: 2,
                       home: '3',
                       away: '4',
                       week_number: 1,
                       comp: 'Premier League')

      create(:club, id: 1)

      (1..11).each do |player_id|
        Selection.create(player_id:, club_id: 1)
      end

      create(:club, id: 2)

      (12..22).each do |player_id|
        Selection.create(player_id:, club_id: 2)
      end

      create(:club, id: 3)

      (23..33).each do |player_id|
        Selection.create(player_id:, club_id: 3)
      end

      create(:club, id: 4)

      (34..44).each do |player_id|
        Selection.create(player_id:, club_id: 4)
      end

      create(:tactic, club_id: 1)
      create(:tactic, club_id: 3)

      selected_week = 1
      competition = 'Premier League'

      fixture_list, selections, tactics = Match.new.send(:initialize_match, selected_week, competition)

      expect(fixture_list.size).to eq(2)
      expect(selections.size).to eq(44)
      expect(tactics.size).to eq(4)
    end
  end
end
