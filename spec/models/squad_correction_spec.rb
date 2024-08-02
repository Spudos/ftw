require 'rails_helper'
require 'pry'

RSpec.describe Club, type: :model do
  describe 'check available players' do
    context 'with more than 11 available players' do
      it 'does not add any players to the club' do
        create(:club,
               managed: true,
               league: 'Premier League',
               name: 'Test Club000',
               ground_name: 'Test Ground000',
               stand_n_name: 'Test Stand N000',
               stand_e_name: 'Test Stand E000',
               stand_s_name: 'Test Stand S000',
               stand_w_name: 'Test Stand W000',
               color_primary: 'Test Color Primary000',
               color_secondary: 'Test Color Secondary000')

        2.times { create(:player) }
        4.times { create(:player, club_id: 1, position: 'dfc', player_position_detail: 'c') }
        4.times { create(:player, club_id: 1, position: 'mid', player_position_detail: 'c') }
        4.times { create(:player, club_id: 1, position: 'att', player_position_detail: 'c') }
        create(:user)
        turn = Turn.new(week: 1)

        Club.new.process_squad_corrections(turn)

        expect(Player.where(club_id: 1).count).to eq(14)
      end
    end

    context 'with less than 11 available players' do
      it 'adds new players to the club so the club always has 12 to pick from' do
        create(:club,
               managed: true,
               league: 'Premier League',
               name: 'Test Club000',
               ground_name: 'Test Ground000',
               stand_n_name: 'Test Stand N000',
               stand_e_name: 'Test Stand E000',
               stand_s_name: 'Test Stand S000',
               stand_w_name: 'Test Stand W000',
               color_primary: 'Test Color Primary000',
               color_secondary: 'Test Color Secondary000')

        2.times { create(:player, club_id: 1, position: 'dfc', player_position_detail: 'c') }
        create(:player, club_id: 1, position: 'mid', player_position_detail: 'c')
        3.times { create(:player, club_id: 1, position: 'att', player_position_detail: 'c') }
        create(:user)
        turn = Turn.new(week: 1)

        Club.new.process_squad_corrections(turn)

        expect(Player.where(club_id: 1, position: 'gkp').count).to eq(1)
        expect(Player.where(club_id: 1, position: 'dfc').count).to eq(5)
        expect(Player.where(club_id: 1, position: 'mid').count).to eq(4)
        expect(Player.where(club_id: 1, position: 'att').count).to eq(3)
        expect(Player.last.value).to_not eq(0)
        expect(Player.last.wages).to_not eq(0)
        expect(Player.last.total_skill).to_not eq(0)
      end
    end
  end
end
