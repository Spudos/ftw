require 'rails_helper'
require 'pry'

RSpec.describe Selection, type: :model do
  describe 'auto select' do
    it "does not select players if a complete selection exists for a managed club" do
      11.times do |n|
        create(:selection, player_id: n + 1)
      end

      create(:club, managed: true)

      11.times do |n|
        create(:player, id: n + 1, club_id: 1)
      end

      params = { week: 1 }
      turn = Turn.new(week: 1)

      Selection.new.auto_selection(params, turn)

      expect(Selection.where(club_id: 1).count).to eq(11)
    end

    it "selects players if an incomplete selection exists for a managed club" do
      5.times do |n|
        create(:selection, player_id: n + 1, club_id: 1)
      end
      create(:club, managed: true)

      2.times do |n|
        create(:player, position: 'gkp', club_id: 1)
      end
      5.times do |n|
        create(:player, position: 'dfc', club_id: 1)
      end
      4.times do |n|
        create(:player, position: 'mid', club_id: 1)
      end
      3.times do |n|
        create(:player, position: 'att', club_id: 1)
      end

      params = { week: 1 }
      turn = Turn.new(week: 1)

      Selection.new.auto_selection(params, turn)

      expect(Selection.where(club_id: 1).count).to eq(11)
    end

    it "selects 11 players for the club" do
      params = { week: 1 }
      create(:club)
      3.times do |n|
        create(:player, position: 'gkp')
      end
      6.times do |n|
        create(:player, position: 'dfc')
      end
      6.times do |n|
        create(:player, position: 'mid')
      end
      6.times do |n|
        create(:player, position: 'att')
      end
      turn = Turn.new(week: 1)

      Selection.new.auto_selection(params, turn)

    club_selection = Selection.where(club_id: 1)
    player_1_position = Player.find_by(id: club_selection[0].player_id)&.position

    expect(player_1_position).to eq('gkp')
    expect(Selection.where(club_id: 1).count).to eq(11)
    end
  end
end
