require 'rails_helper'
require 'pry'

RSpec.describe Turn::PlayerUpdates, type: :model do
  describe 'player_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, club_id: 1, var1: 'train', var2: 'Woolley', var3: 'Tackling', date_completed: nil)
      week = 1
      action_id = '10011'

      allow_any_instance_of(Turn::PlayerUpdates).to receive(:train_player)

      expect(Turn::PlayerUpdates).to receive(:train_player).with(action_id, week, turn.club_id, turn.var2, turn.var3)

      Turn::PlayerUpdates.new(week).player_upgrade(week)
binding.pry
      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club_id]).to eq(1)
      expect(Turn.first[:var1]).to eq('train')
      expect(Turn.first[:var2]).to eq('Woolley')
      expect(Turn.first[:var3]).to eq('Tackling')
      expect(Turn.first[:date_completed]).to_not be_nil
    end
  end

  describe 'train_player' do
    it 'increases the skill by 1 point as the coach > skill and he has potential' do
      week = 1
      action_id = '10011'
      club = '001'
      player = 'Woolley'
      skill = 'tackling'

      create(:club, staff_dfc: 10)
      create(:player, position: 'dfc')

      Turn::PlayerUpdates.new(week).train_player(action_id, week, club, player, skill)

      player = Player.find_by(name: 'Woolley')

      expect(player.tackling).to eq(6)
      expect(Message.first[:var1]).to eq("Training #{player.name} in #{skill} suceeded! His new value is #{player.tackling}")
    end

    it 'will not increse the skill by 1 point as the coach > skill and he has no potential' do
      week = 1
      action_id = '10011'
      club = '001'
      player = 'Woolley'
      skill = 'tackling'

      create(:club, staff_dfc: 10)
      create(:player, position: 'dfc', potential_tackling: 5)

      Turn::PlayerUpdates.new(week).train_player(action_id, week, club, player, skill)

      player = Player.find_by(name: 'Woolley')

      expect(player.tackling).to eq(5)
      expect(Message.first[:var1]).to eq("Training #{player.name} in #{skill} failed due to reaching potential")
    end

    it 'will not increse the skill by 1 point as the coach < skill and he has no potential' do
      week = 1
      action_id = '10011'
      club = '001'
      player = 'Woolley'
      skill = 'tackling'

      create(:club, staff_dfc: 4)
      create(:player, position: 'dfc', potential_tackling: 5)

      Turn::PlayerUpdates.new(week).train_player(action_id, week, club, player, skill)

      player = Player.find_by(name: 'Woolley')

      expect(player.tackling).to eq(5)
      expect(Message.first[:var1]).to eq("Training #{player.name} in #{skill} failed due to reaching potential")
    end

    it 'will not increse the skill by 1 point as the coach < skill but he has potential' do
      week = 1
      action_id = '10011'
      club = '001'
      player = 'Woolley'
      skill = 'tackling'

      create(:club, staff_dfc: 4)
      create(:player, position: 'dfc', potential_tackling: 10)

      Turn::PlayerUpdates.new(week).train_player(action_id, week, club, player, skill)

      player = Player.find_by(name: 'Woolley')

      expect(player.tackling).to eq(5)
      expect(Message.first[:var1]).to eq("Training #{player.name} in #{skill} failed - this coach isn't good enough to train #{skill} for #{player.name}")
    end
  end

  describe 'fitness_upgrade' do
    it 'updates the turn records and performs necessary actions' do
      turn = create(:turn, var1: 'fitness', var2: 'Woolley', var3: nil, date_completed: nil)
      week = 1
      action_id = '10011'

      allow_any_instance_of(Turn::PlayerUpdates).to receive(:player_fitness)

      expect(turn).to receive(Turn::PlayerUpdates(:player_fitness)).with(action_id, week, turn.club, turn.var2)

      turn.send(:fitness_upgrade, week)

      expect(Turn.first[:week]).to eq(1)
      expect(Turn.first[:club]).to eq('001')
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
      club = '001'
      player = 'Woolley'

      create(:club, staff_fitness: 8)
      create(:player, fitness: 90)

      Turn::PlayerUpdates.new(week).player_fitness(action_id, week, club, player)

      player = Player.find_by(name: 'Woolley')

      expect(player.fitness).to eq(98)
      expect(Message.first[:var1]).to eq("Fitness training for #{player.name} was completed! His new value is #{player.fitness}")
    end

    it 'will not change the fitness as it is already at 100' do
      week = 1
      action_id = '10011'
      club = '001'
      player = 'Woolley'

      create(:club, staff_fitness: 8)
      create(:player, fitness: 100)

      Turn::PlayerUpdates.new(week).player_fitness(action_id, week, club, player)

      player = Player.find_by(name: 'Woolley')

      expect(player.fitness).to eq(100)
      expect(Message.first[:var1]).to eq("Fitness training for #{player.name} was completed! His new value is #{player.fitness}")
    end

    it 'will change fitness to 100 as it is above 100' do
      week = 1
      action_id = '10011'
      club = '001'
      player = 'Woolley'

      create(:club, staff_fitness: 8)
      create(:player, fitness: 130)

      Turn::PlayerUpdates.new(week).player_fitness(action_id, week, club, player)

      player = Player.find_by(name: 'Woolley')

      expect(player.fitness).to eq(100)
      expect(Message.first[:var1]).to eq("Fitness training for #{player.name} was completed! His new value is #{player.fitness}")
    end

    it 'will change fitness to 100 as it is above 100 after the fitness change is applied' do
      week = 1
      action_id = '10011'
      club = '001'
      player = 'Woolley'

      create(:club, staff_fitness: 8)
      create(:player, fitness: 98)

      Turn::PlayerUpdates.new(week).player_fitness(action_id, week, club, player)

      player = Player.find_by(name: 'Woolley')

      expect(player.fitness).to eq(100)
      expect(Message.first[:var1]).to eq("Fitness training for #{player.name} was completed! His new value is #{player.fitness}")
    end
  end

  describe 'fitness increase' do
    let(:week) { 1 }

    it 'does not effect fitness' do
      create(:player, fitness: 100)

      adjusted_player = Turn::PlayerUpdates.new(week).fitness_increase

      expect(adjusted_player[0][:fitness]).to eq(100)
    end

    it 'sets fitness to 100' do
      create(:player, fitness: 110)

      adjusted_player = Turn::PlayerUpdates.new(week).fitness_increase

      expect(adjusted_player[0][:fitness]).to eq(100)
    end

    it 'increases the fitness by 3' do
      create(:player, fitness: 0)
      allow_any_instance_of(Kernel).to receive(:rand).with(0..5).and_return(3)

      adjusted_player = Turn::PlayerUpdates.new(week).fitness_increase

      expect(adjusted_player[0][:fitness]).to eq(3)
    end
  end

  describe 'contract_decrease' do
  let(:week) { 1 }

    it 'reduces the contract by 1' do
      create(:player, contract: 20)
      adjusted_player = Turn::PlayerUpdates.new(week).contract_decrease

      expect(adjusted_player[0][:contract]).to eq(19)
    end

    it 'does not reduce the contract past 0' do
      create(:player, contract: 0)

      adjusted_player = Turn::PlayerUpdates.new(week).contract_decrease

      expect(adjusted_player[0][:contract]).to eq(0)
    end

    it 'sets the contract to 0 as it was negative' do
      create(:player, contract: -20)

      adjusted_player = Turn::PlayerUpdates.new(week).contract_decrease

      expect(adjusted_player[0][:contract]).to eq(0)
    end
  end

  describe 'player_value' do
    it 'calculates the correct player value' do
      create(:player)
      create(:club)
      week = 1

      Turn::PlayerUpdates.new(week).player_value

      player = Player.first

      expect(player.value).to eq(42929250)
    end
  end

  describe 'player_wage' do
    it 'calculates the correct player wage' do
      create(:player)
      create(:club)
      week = 1

      Turn::PlayerUpdates.new(week).player_wages

      player = Player.first

      expect(player.wages).to eq(172125)
    end
  end
end
