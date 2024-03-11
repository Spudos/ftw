require 'rails_helper'
require 'pry'

RSpec.describe Player, type: :model do
  describe 'perform club creation' do
    context 'with valid club data' do
      it 'update an existing club to show the new values' do
        create(:club,
               managed: false,
               league: 'Premier League',
               name: 'Test Club000',
               ground_name: 'Test Ground000',
               stand_n_name: 'Test Stand N000',
               stand_e_name: 'Test Stand E000',
               stand_s_name: 'Test Stand S000',
               stand_w_name: 'Test Stand W000',
               color_primary: 'Test Color Primary000',
               color_secondary: 'Test Color Secondary000')

        create(:club, id: 242)
        create(:player)
        create(:player)

        params = { club: { managed: false,
                           league: 'Premier League',
                           name: 'Test Club',
                           ground_name: 'Test Ground',
                           stand_n_name: 'Test Stand N',
                           stand_e_name: 'Test Stand E',
                           stand_s_name: 'Test Stand S',
                           stand_w_name: 'Test Stand W',
                           color_primary: 'Test Color Primary',
                           color_secondary: 'Test Color Secondary',
                           stadium_points: 5,
                           bank_points: 5,
                           fanbase_points: 5,
                           player_type: 'junior' } }

        Club.new.submission(params)

        expect(Club.first.name).to be == 'Test Club'
        expect(Club.first.managed).to be == true
        expect(Club.first.ground_name).to be == 'Test Ground'
        expect(Club.first.stand_n_name).to be == 'Test Stand N'
        expect(Club.first.stand_e_name).to be == 'Test Stand E'
        expect(Club.first.stand_s_name).to be == 'Test Stand S'
        expect(Club.first.stand_w_name).to be == 'Test Stand W'
        expect(Club.first.color_primary).to be == 'Test Color Primary'
        expect(Club.first.color_secondary).to be == 'Test Color Secondary'
        expect(Club.first.stand_n_capacity).to be_between(8250, 8750)
        expect(Club.first.stand_n_condition).to be_between(5, 8)
        expect(Club.first.pitch).to be_between(5, 8)
        expect(Club.first.facilities).to be_between(5, 8)
        expect(Club.first.hospitality).to be_between(5, 8)
        expect(Club.first.stand_e_capacity).to be_between(8250, 8750)
        expect(Club.first.stand_e_condition).to be_between(5, 8)
        expect(Club.first.stand_s_capacity).to be_between(8250, 8750)
        expect(Club.first.stand_s_condition).to be_between(5, 8)
        expect(Club.first.stand_w_capacity).to be_between(8250, 8750)
        expect(Club.first.stand_w_condition).to be_between(5, 8)
        expect(Club.first.staff_gkp).to be_between(5, 8)
        expect(Club.first.staff_dfc).to be_between(5, 8)
        expect(Club.first.staff_mid).to be_between(5, 8)
        expect(Club.first.staff_att).to be_between(5, 8)
        expect(Club.first.staff_scouts).to be_between(5, 8)
        expect(Club.first.bank_bal).to eq(500_000_000)
        expect(Club.first.fanbase).to eq(70_000)
        expect(Player.first.club_id).to eq(242)
        expect(Player.second.club_id).to eq(242)
        expect(Player.where(club_id: 1).count).to eq(21)
        expect(Player.last.total_skill).to_not be(0)
        expect(Player.last.wages).to_not be(0)
        expect(Player.last.value).to_not be(0)
      end
    end
  end
end
