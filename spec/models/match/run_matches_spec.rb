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

      create(:player, id: 1)
      create(:player, id: 2, position: 'dfc')
      create(:player, id: 3, position: 'dfc')
      create(:player, id: 4, position: 'dfc')
      create(:player, id: 5, position: 'dfc')
      create(:player, id: 6, position: 'mid')
      create(:player, id: 7, position: 'mid')
      create(:player, id: 8, position: 'mid')
      create(:player, id: 9, position: 'mid')
      create(:player, id: 10, position: 'att')
      create(:player, id: 11, position: 'att')

      (1..11).each do |player_id|
        Selection.create(player_id:, club_id: 1)
      end

      create(:club, id: 2)

      create(:player, id: 12, club_id: 2)
      create(:player, id: 13, position: 'dfc', club_id: 2)
      create(:player, id: 14, position: 'dfc', club_id: 2)
      create(:player, id: 15, position: 'dfc', club_id: 2)
      create(:player, id: 16, position: 'dfc', club_id: 2)
      create(:player, id: 17, position: 'mid', club_id: 2)
      create(:player, id: 18, position: 'mid', club_id: 2)
      create(:player, id: 19, position: 'mid', club_id: 2)
      create(:player, id: 20, position: 'mid', club_id: 2)
      create(:player, id: 21, position: 'att', club_id: 2)
      create(:player, id: 22, position: 'att', club_id: 2)

      (12..22).each do |player_id|
        Selection.create(player_id:, club_id: 2)
      end

      create(:club, id: 3)

      create(:player, id: 23, club_id: 2)
      create(:player, id: 24, position: 'dfc', club_id: 3)
      create(:player, id: 25, position: 'dfc', club_id: 3)
      create(:player, id: 26, position: 'dfc', club_id: 3)
      create(:player, id: 27, position: 'dfc', club_id: 3)
      create(:player, id: 28, position: 'mid', club_id: 3)
      create(:player, id: 29, position: 'mid', club_id: 3)
      create(:player, id: 30, position: 'mid', club_id: 3)
      create(:player, id: 31, position: 'mid', club_id: 3)
      create(:player, id: 32, position: 'att', club_id: 3)
      create(:player, id: 33, position: 'att', club_id: 3)

      (23..33).each do |player_id|
        Selection.create(player_id:, club_id: 3)
      end

      create(:club, id: 4)

      create(:player, id: 34, club_id: 2)
      create(:player, id: 35, position: 'dfc', club_id: 4)
      create(:player, id: 36, position: 'dfc', club_id: 4)
      create(:player, id: 37, position: 'dfc', club_id: 4)
      create(:player, id: 38, position: 'dfc', club_id: 4)
      create(:player, id: 39, position: 'mid', club_id: 4)
      create(:player, id: 40, position: 'mid', club_id: 4)
      create(:player, id: 41, position: 'mid', club_id: 4)
      create(:player, id: 42, position: 'mid', club_id: 4)
      create(:player, id: 43, position: 'att', club_id: 4)
      create(:player, id: 44, position: 'att', club_id: 4)

      (34..44).each do |player_id|
        Selection.create(player_id:, club_id: 4)
      end

      create(:tactic, club_id: 1)
      create(:tactic, club_id: 3)

      selected_week = 1
      competition = 'Premier League'

      fixture_list, selection, tactic = Match.new.run_matches(selected_week, competition)

      binding.pry
    end
  end
end
