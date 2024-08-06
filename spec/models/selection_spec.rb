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

    it "selects 11 players for the club and no selection exists" do
      params = { week: 1 }
      create(:club)
      3.times do |n|
        create(:player, position: 'gkp')
      end
      5.times do |n|
        create(:player, position: 'dfc')
      end
      4.times do |n|
        create(:player, position: 'mid')
      end
      4.times do |n|
        create(:player, position: 'att')
      end
      turn = Turn.new(week: 1)

      Selection.new.auto_selection(params, turn)
      club_selection = Selection.all

      expect(Player.find_by(id: club_selection[0].player_id)&.position).to eq('gkp')
      expect(Selection.where(club_id: 1).count).to eq(11)
    end

    it "selects 11 players for the club bercause an injured player has been inlcuded" do
      create(:selection, player_id: 1)
      create(:selection, player_id: 2)
      create(:selection, player_id: 3)
      create(:selection, player_id: 4)
      create(:selection, player_id: 5)
      create(:selection, player_id: 6)
      create(:selection, player_id: 7)
      create(:selection, player_id: 8)
      create(:selection, player_id: 9)
      create(:selection, player_id: 10)
      create(:selection, player_id: 11)

      create(:club, managed: true)

      create(:player, id: 1, club_id: 1, available: 5, position: 'gkp')
      create(:player, id: 2, club_id: 1, available: 0, position: 'dfc')
      create(:player, id: 3, club_id: 1, available: 0, position: 'dfc')
      create(:player, id: 4, club_id: 1, available: 0, position: 'dfc')
      create(:player, id: 5, club_id: 1, available: 5, position: 'dfc')
      create(:player, id: 6, club_id: 1, available: 0, position: 'dfc')
      create(:player, id: 7, club_id: 1, available: 0, position: 'mid')
      create(:player, id: 8, club_id: 1, available: 0, position: 'mid')
      create(:player, id: 9, club_id: 1, available: 5, position: 'mid')
      create(:player, id: 10, club_id: 1, available: 0, position: 'mid')
      create(:player, id: 11, club_id: 1, available: 5, position: 'att')
      create(:player, id: 12, club_id: 1, available: 0, position: 'gkp')
      create(:player, id: 13, club_id: 1, available: 0, position: 'mid')
      create(:player, id: 14, club_id: 1, available: 0, position: 'att')
      create(:player, id: 15, club_id: 1, available: 0, position: 'att')
      create(:player, id: 16, club_id: 1, available: 0, position: 'dfc')
      create(:player, id: 17, club_id: 1, available: 0, position: 'att')

      params = { week: 1 }
      turn = Turn.new(week: 1)

      Selection.new.auto_selection(params, turn)

      selection = Selection.all

      selection.each do |player|
        injury = Player.find_by(id: player.player_id)&.available
        expect(injury).to eq(0)
      end

      expect(Selection.where(club_id: 1).count).to eq(11)
    end
  end
end
