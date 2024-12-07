require 'rails_helper'
require 'pry'

RSpec.describe TurnActions, type: :model do
  describe 'scout for a player' do
    context 'with all player criteria' do
      it 'should return the correct player' do
        create(:club, id: 1, managed: true)
        create(:club, id: 2, managed: false)
        create(:club, id: 3, managed: false)
        create(:player, club_id: 2, age: 25, loyalty: 30)
        create(:player, club_id: 3, age: 30, loyalty: 10)

        scout_info = { week: 1,
                       club_id: 1,
                       position: 'gkp',
                       total_skill: 0,
                       age: 35,
                       skills: 'gkp',
                       loyalty: false,
                       potential_skill: 'gkp',
                       consistency: false,
                       recovery: false,
                       star: false,
                       blend: 'woolley' }

        TurnActions::Engines::Scouting.new(scout_info).call
      end
    end
  end
end
