require 'rails_helper'
require 'pry'

RSpec.describe Turn, type: :model do
  describe 'call: player_upgrade' do
    it 'upgrades tackling by 1 point' do
      week = 1
      create(:turn, club_id: 1, var1: 'train', var2: 'Woolley', var3: 'Tackling', date_completed: nil)
      create(:club, id: 1, staff_dfc: 10)
      create(:player, name: 'Woolley', position: 'dfc')

      turn_double = class_double("Turn::TurnActions").as_stubbed_const

      allow(turn_double).to receive(:call)
      turn_double.call(week)

      expect(Player.first.tackling).to eq(6)
    end
  end

  describe 'train_player' do
    it 'increases the skill by 1 point as the coach > skill and he has potential' do
      week = 1
      action_id = '10011'
      club_id = 1
      player = 'Woolley'
      skill = 'tackling'

      create(:club, staff_dfc: 10)
      create(:player, position: 'dfc')

      Turn::TurnActions.new(week).train_player(action_id, week, club_id, player, skill)

      player = Player.find_by(name: 'Woolley')

      expect(player.tackling).to eq(6)
      expect(Message.first[:var1]).to eq("Training #{player.name} in #{skill} suceeded! His new value is #{player.tackling}")
    end

    it 'will not increse the skill by 1 point as the coach > skill and he has no potential' do
      week = 1
      action_id = '10011'
      club_id = 1
      player = 'Woolley'
      skill = 'tackling'

      create(:club, staff_dfc: 10)
      create(:player, position: 'dfc', potential_tackling: 5)

      Turn::TurnActions.new(week).train_player(action_id, week, club_id, player, skill)

      player = Player.find_by(name: 'Woolley')

      expect(player.tackling).to eq(5)
      expect(Message.first[:var1]).to eq("Training #{player.name} in #{skill} failed due to reaching potential")
    end

    it 'will not increse the skill by 1 point as the coach < skill and he has no potential' do
      week = 1
      action_id = '10011'
      club_id = 1
      player = 'Woolley'
      skill = 'tackling'

      create(:club, staff_dfc: 4)
      create(:player, position: 'dfc', potential_tackling: 5)

      Turn::TurnActions.new(week).train_player(action_id, week, club_id, player, skill)

      player = Player.find_by(name: 'Woolley')

      expect(player.tackling).to eq(5)
      expect(Message.first[:var1]).to eq("Training #{player.name} in #{skill} failed due to reaching potential")
    end

    it 'will not increse the skill by 1 point as the coach < skill but he has potential' do
      week = 1
      action_id = '10011'
      club_id = 1
      player = 'Woolley'
      skill = 'tackling'

      create(:club, staff_dfc: 4)
      create(:player, position: 'dfc', potential_tackling: 10)

      Turn::TurnActions.new(week).train_player(action_id, week, club_id, player, skill)

      player = Player.find_by(name: 'Woolley')

      expect(player.tackling).to eq(5)
      expect(Message.first[:var1]).to eq("Training #{player.name} in #{skill} failed - this coach isn't good enough to train #{skill} for #{player.name}")
    end
  end

  describe 'fitness_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, week: 1, club_id: 1, var1: 'fitness', var2: 'Woolley', var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'

      allow_any_instance_of(Turn::TurnActions).to receive(:player_fitness)

      expect(turn).to receive(Turn::TurnActions(:player_fitness)).with(action_id, week, turn.club_id, turn.var2)

      turn.send(:fitness_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club]).to eq(1)
      expect(Turn.first[:var1]).to eq('fitness')
      expect(Turn.first[:var2]).to eq('Woolley')
      expect(Turn.first[:var3]).to eq(nil)
      expect(Turn.first[:date_completed]).to_not be_nil
    end
  end

  describe 'player_fitness' do
    let(:week) { 1 }

    it 'will increase the players fitness by 8' do
      week = 1
      action_id = '10011'
      club_id = 1
      player = 'Woolley'

      create(:club, staff_fitness: 8)
      create(:player, fitness: 90)

      Turn::TurnActions.new(week).player_fitness(action_id, week, club_id, player)

      player = Player.find_by(name: 'Woolley')

      expect(player.fitness).to eq(98)
      expect(Message.first[:var1]).to eq("Fitness training for #{player.name} was completed! His new value is #{player.fitness}")
    end

    it 'will not change the fitness as it is already at 100' do
      week = 1
      action_id = '10011'
      club_id = 1
      player = 'Woolley'

      create(:club, staff_fitness: 8)
      create(:player, fitness: 100)

      Turn::TurnActions.new(week).player_fitness(action_id, week, club_id, player)

      player = Player.find_by(name: 'Woolley')

      expect(player.fitness).to eq(100)
      expect(Message.first[:var1]).to eq("Fitness training for #{player.name} was completed! His new value is #{player.fitness}")
    end

    it 'will change fitness to 100 as it is above 100' do
      week = 1
      action_id = '10011'
      club_id = 1
      player = 'Woolley'

      create(:club, staff_fitness: 8)
      create(:player, fitness: 130)

      Turn::TurnActions.new(week).player_fitness(action_id, week, club_id, player)

      player = Player.find_by(name: 'Woolley')

      expect(player.fitness).to eq(100)
      expect(Message.first[:var1]).to eq("Fitness training for #{player.name} was completed! His new value is #{player.fitness}")
    end

    it 'will change fitness to 100 as it is above 100 after the fitness change is applied' do
      week = 1
      action_id = '10011'
      club_id = 1
      player = 'Woolley'

      create(:club, staff_fitness: 8)
      create(:player, fitness: 98)

      Turn::TurnActions.new(week).player_fitness(action_id, week, club_id, player)

      player = Player.find_by(name: 'Woolley')

      expect(player.fitness).to eq(100)
      expect(Message.first[:var1]).to eq("Fitness training for #{player.name} was completed! His new value is #{player.fitness}")
    end
  end

  describe 'stadium_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, week: 1, club_id: 1, var1: 'stand_n_capacity', var2: 5000, var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'
      cost = 5000000

      Turn::TurnActions.new(week)

      allow_any_instance_of(Turn::TurnActions).to receive(:bank_adjustment)
      allow_any_instance_of(Turn::TurnActions).to receive(:add_to_stadium_upgrades)

      expect(Turn::TurnActions).to receive(:add_to_stadium_upgrades).with(action_id, week, turn.club_id, turn.var1, turn.var2)
      expect(Turn::TurnActions).to receive(:bank_adjustment).with(action_id, week, turn.club_id, turn.var1, turn.var2, cost)

      turn.send(:stadium_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club]).to eq(1)
      expect(Turn.first[:var1]).to eq('stand_n_capacity')
      expect(Turn.first[:var2]).to eq('5000')
      expect(Turn.first[:var3]).to eq(nil)
      expect(Turn.first[:date_completed]).to_not be_nil
    end
  end

  describe 'add_to_stadium_upgrades' do
    it 'adds the upgrade to the upgrade table' do
      action_id = 'test'
      week = 1
      club_id = 1
      stand = 'stand_n_capacity'
      seats = 5000

      Turn::TurnActions.new(week).add_to_stadium_upgrades(action_id, week, club_id, stand, seats)

      upgrade = Upgrade.first

      expect(upgrade[:action_id]).to eq('test')
      expect(upgrade[:week]).to eq(1)
      expect(upgrade[:club_id].to_i).to eq(1)
      expect(upgrade[:var1]).to eq('stand_n_capacity')
      expect(upgrade[:var2]).to eq('5000')
      expect(upgrade[:var3]).to eq(0)
    end
  end

  describe 'property_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, week: 1, club_id: 1, var1: 'property', var2: 'pitch', var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'

      allow_any_instance_of(Turn).to receive(:bank_adjustment)
      allow_any_instance_of(Turn).to receive(:add_to_property_upgrades)

      expect(turn).to receive(:bank_adjustment).with(action_id, week, turn.club_id, turn.var1, turn.var2, turn.var3)
      expect(turn).to receive(:add_to_property_upgrades).with(action_id, week, turn.club_id, turn.var2)

      turn.send(:property_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club_id].to_i).to eq(1)
      expect(Turn.first[:var1]).to eq('property')
      expect(Turn.first[:var2]).to eq('pitch')
      expect(Turn.first[:var3]).to eq(nil)
      expect(Turn.first[:date_completed]).to_not be_nil
    end
  end

  describe 'add_to_property_upgrades' do
    it 'adds the upgrade to the upgrade table' do
      action_id = 'test'
      week = 1
      club_id = 1
      prop = 'pitch'

      Turn::TurnActions.new(week).add_to_property_upgrades(action_id, week, club_id, prop)

      upgrade = Upgrade.first

      expect(upgrade[:action_id]).to eq('test')
      expect(upgrade[:week]).to eq(1)
      expect(upgrade[:club_id].to_i).to eq(1)
      expect(upgrade[:var1]).to eq('pitch')
      expect(upgrade[:var2]).to eq(nil)
      expect(upgrade[:var3]).to eq(0)
    end
  end

  describe 'coach_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, week: 1, club_id: 1, var1: 'coach', var2: 'dfc', var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'

      allow_any_instance_of(Turn).to receive(:bank_adjustment)
      allow_any_instance_of(Turn).to receive(:add_to_coach_upgrades)

      expect(turn).to receive(:bank_adjustment).with(action_id, week, turn.club_id, turn.var1, turn.var2, turn.var3)
      expect(turn).to receive(:add_to_coach_upgrades).with(action_id, week, turn.club_id, turn.var2)

      turn.send(:coach_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club_id].to_i).to eq(1)
      expect(Turn.first[:var1]).to eq('coach')
      expect(Turn.first[:var2]).to eq('dfc')
      expect(Turn.first[:var3]).to eq(nil)
      expect(Turn.first[:date_completed]).to_not be_nil
    end
  end

  describe 'add_to_coach_upgrades' do
    it 'adds the upgrade to the upgrade table' do
      action_id = 'test'
      week = 1
      club_id = 1
      coach = 'dfc'

      Turn::TurnActions.new(week).add_to_coach_upgrades(action_id, week, club_id, coach)

      upgrade = Upgrade.first

      expect(upgrade[:action_id]).to eq('test')
      expect(upgrade[:week]).to eq(1)
      expect(upgrade[:club_id].to_i).to eq(1)
      expect(upgrade[:var1]).to eq('dfc')
      expect(upgrade[:var2]).to eq(nil)
      expect(upgrade[:var3]).to eq(0)
    end
  end
end
