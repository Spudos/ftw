require 'rails_helper'
require 'pry'

RSpec.describe Turn::PlayerUpdates, type: :model do
  describe 'player_update' do
    let(:week) { 1 }

    it 'fitness increases by 3, contract decreases by 1, value and wages calculated' do
      create(:club, id: 1, managed: true)
      create(:player, id: 100, available: 0)
      create(:player,
              id: 1,
              club_id: 1,
              fitness: 50,
              contract: 24,
              available: 0
              )
      create(:performance, player_id: 1)
      create(:goal, scorer_id: 1)
      create(:goal, scorer_id: 1)
      create(:goal, assist_id: 1)
      create(:goal, assist_id: 1)
      create(:goal, assist_id: 1)

      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..6).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(3)

      Turn::PlayerUpdates.new(week).call

      expect(Player.first.fitness).to eq(53)
      expect(Player.first.available).to eq(3)
      expect(Player.first.contract).to eq(23)
      expect(Player.first.value).to eq(42929250)
      expect(Player.first.wages).to eq(87125)
      expect(Player.first.total_skill).to eq(85)
      expect(Player.first.games_played).to eq(1)
      expect(Player.first.total_goals).to eq(2)
      expect(Player.first.total_assists).to eq(3)
      expect(Player.first.average_performance).to eq(50)
    end

    it 'no contract decrease as it is an unmagaed club' do
      create(:club, id: 1, managed: false)
      create(:player,
              club_id: 1,
              fitness: 50,
              contract: 24,
              available: 0
              )

      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..6).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(3)

      Turn::PlayerUpdates.new(week).call

      expect(Player.first.contract).to eq(24)
    end

    it 'fitness increases to 100' do
      create(:club, id: 1, managed: true)
      create(:player,
              club_id: 1,
              fitness: 99,
              contract: 24,
              available: 0
              )

      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..6).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(3)

      Turn::PlayerUpdates.new(week).call

      expect(Player.first.fitness).to eq(100)
    end

    it 'fitness corrected to 100' do
      create(:club, id: 1, managed: true)
      create(:player,
              club_id: 1,
              fitness: 200,
              contract: 24,
              available: 0
              )

      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..6).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(3)

      Turn::PlayerUpdates.new(week).call

      expect(Player.first.fitness).to eq(100)
    end

    it 'random injury suffered' do
      create(:club, id: 1, managed: true)
      create(:player,
              club_id: 1,
              fitness: 90,
              contract: 24,
              available: 0
              )

      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(1)
      allow_any_instance_of(Kernel).to receive(:rand).with(20..40).and_return(35)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..6).and_return(3)

      Turn::PlayerUpdates.new(week).call

      expect(Player.first.fitness).to eq(58)
      expect(Player.first.available).to eq(3)
    end

    it 'contract reaches 3 so warning generated' do
      create(:club, id: 1, managed: true)
      create(:player,
              club_id: 1,
              fitness: 100,
              contract: 4,
              available: 0
              )

      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..6).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(3)

      Turn::PlayerUpdates.new(week).call

      expect(Player.first.contract).to eq(3)
      expect(Player.first.club_id).to eq(1)
      expect(Message.first.club_id).to eq('1')
    end

    it 'contract reaches 0 so player moved to club 242' do
      create(:club, id: 1, managed: true)
      create(:club, id: 242)
      create(:player,
            club_id: 1,
            fitness: 100,
            contract: 1,
            available: 0
            )

      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..6).and_return(3)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(3)

      Turn::PlayerUpdates.new(week).call

      expect(Player.first.contract).to eq(51)
      expect(Player.first.club_id).to eq(242)
    end
  end
end
