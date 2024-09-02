require 'rails_helper'
require 'pry'

RSpec.describe SquadAction, type: :model do
  describe 'blend players' do
    it 'gets the average of the existing players excluding the highest and moves it towards the others on a sucessful roll' do
      club = Club.create(name: 'Test Club')

      Player.create(club_id: club.id, position: 'dfc', blend: 1)
      Player.create(club_id: club.id, position: 'dfc', blend: 2)
      Player.create(club_id: club.id, position: 'dfc', blend: 3)
      Player.create(club_id: club.id, position: 'dfc', blend: 3)

      Player.create(id: 10, club_id: club.id, position: 'dfc', blend: 5)

      action_id = '421blend'
      week = 1
      club_id = Club.find(club.id).id
      player_id = 10
      amount = 4_000_000
      turn = Turn.create(week: 1)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(45)

      TurnActions::Engines::Blend.new(action_id,
                                      week,
                                      turn,
                                      club_id,
                                      player_id,
                                      amount).call

      expect(Player.find_by(id: 10).blend).to eq(4)
      expect(Message.first.var1).to eq("This week, you spent a significant amount on team building activities and extra training for your dfc players. The blending process was successful")
      expect(Club.first.bank_bal).to eq(-4_000_000)
    end

    it 'adds failure message on a unsucessful roll' do
      club = Club.create(name: 'Test Club')


      Player.create(club_id: club.id, position: 'dfc', blend: 1)
      Player.create(club_id: club.id, position: 'dfc', blend: 2)
      Player.create(club_id: club.id, position: 'dfc', blend: 3)
      Player.create(club_id: club.id, position: 'dfc', blend: 3)


      Player.create(id: 10, club_id: club.id, position: 'dfc', blend: 5)

      action_id = '421blend'
      week = 1
      club_id = Club.find(club.id).id
      player_id = 10
      amount = 4_000_000
      turn = Turn.create(week: 1)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(55)

      TurnActions::Engines::Blend.new(action_id,
                                      week,
                                      turn,
                                      club_id,
                                      player_id,
                                      amount).call

      expect(Player.find_by(id: 10).blend).to eq(5)
      expect(Message.first.var1).to eq("This week, you spent a significant amount on team building activities and extra training for your dfc players. Despite the efforts of your staff, the blending process failed")
      expect(Club.first.bank_bal).to eq(-4_000_000)
    end

    it 'adds failure message if only one player in that position in the squad' do
      club = Club.create(name: 'Test Club')

      Player.create(id: 10, club_id: club.id, position: 'dfc', blend: 5)

      action_id = '421blend'
      week = 1
      club_id = Club.find(club.id).id
      player_id = 10
      amount = 4_000_000
      turn = Turn.create(week: 1)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(45)

      TurnActions::Engines::Blend.new(action_id,
                                      week,
                                      turn,
                                      club_id,
                                      player_id,
                                      amount).call

      expect(Player.find_by(id: 10).blend).to eq(5)
      expect(Message.first.var1).to eq("This week, you spent a significant amount on team building activities and extra training for your dfc players. Despite the efforts of your staff, the blending process failed")
      expect(Club.first.bank_bal).to eq(-4_000_000)
    end
  end
end
