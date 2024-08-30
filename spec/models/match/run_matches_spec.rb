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

      create(:club, id: 1,
                    name: 'club1',
                    stand_n_capacity: 1000,
                    stand_s_capacity: 1000,
                    stand_e_capacity: 1000,
                    stand_w_capacity: 1000,
                    fanbase: 10_000,
                    fan_happiness: 100)

      create(:player, id: 1)
      create(:player, id: 2, position: 'dfc')
      create(:player, id: 3, position: 'dfc')
      create(:player, id: 4, position: 'dfc')
      create(:player, id: 5, position: 'mid')
      create(:player, id: 6, position: 'mid')
      create(:player, id: 7, position: 'mid')
      create(:player, id: 8, position: 'mid')
      create(:player, id: 9, position: 'mid')
      create(:player, id: 10, position: 'att')
      create(:player, id: 11, position: 'att')

      (1..11).each do |player_id|
        Selection.create(player_id:, club_id: 1)
      end

      create(:club, id: 2, name: 'club2')

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

      create(:club, id: 3,
                    name: 'club3',
                    stand_n_capacity: 10_000,
                    stand_s_capacity: 10_000,
                    stand_e_capacity: 10_000,
                    stand_w_capacity: 10_000,
                    fanbase: 100_000,
                    fan_happiness: 100)

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

      create(:club, id: 4, name: 'club4')

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

      Template.create(commentary_type: 'match_general', text: '{team} applies pressure in the midfield, but fails to find a way through the opponents defense')
      Template.create(commentary_type: 'match_chance', text: '{team} have a chance but its off target')
      Template.create(commentary_type: 'match_chance_tar', text: '{team} have a chance but the keeper saves')
      Template.create(commentary_type: 'match_goal', text: '{team} score a goal, {assister} with the assist and {scorer} with the goal')

      selected_week = 1
      competition = 'Premier League'

      turn = Turn.create(week: selected_week)

      GameParam.create(chance_factor: 3, midfield_on_attack: 0.5, target_factor: 60, goal_factor: 40)

      Match.new.run_matches(selected_week, competition, turn)
    end
  end
end
