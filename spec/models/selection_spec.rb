require 'rails_helper'
require 'pry'

RSpec.describe Selection, type: :model do
  describe 'auto select' do
    it "does not select players if a selection exists for a managed club" do
      11.times do |n|
        create(:selection, player_id: n + 1)
      end
    create(:club, managed: true)
    params = {week: 1}

    Selection.new.auto_selection(params)

    club_selection = Selection.where(club_id: 1).count

    expect(club_selection).to eq(11)
    end

    it "selects players if an incomplete selection exists for a managed club" do
      5.times do |n|
        create(:selection, player_id: n + 1)
      end
      create(:club, managed: true)

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

    params = {week: 1}

    Selection.new.auto_selection(params)

    club_selection = Selection.where(club_id: 1).count

    expect(club_selection).to eq(11)
    end

    it "selects 11 players for the club" do
      params = {week: 1}
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

    Selection.new.auto_selection(params)

    club_selection = Selection.where(club_id: 1)
    player_1_position = Player.find_by(id: club_selection[0].player_id)&.position

    expect(player_1_position).to eq('gkp')
    expect(Selection.where(club_id: 1).count).to eq(11)
    end
  end
end
