require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinuteScored, type: :model do
  describe 'decides if a home goal was scored' do
    let(:team1) { { team: '1', defense: 200, midfield: 250, attack: 100 } }
    let(:team2) { { team: '2', defense: 250, midfield: 200, attack: 150 } }
    let(:selection_match) { [team1, team2] }

    minute_by_minute_target = { minute: 1, chance_on_target: 'home' }

    it 'return that the goal was scored' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)

      chance = Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, selection_match).call

      expect(chance[:goal_scored]).to eq('home')
    end

    it 'return that the goal was not scored' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(90)

      chance = Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, selection_match).call

      expect(chance[:goal_scored]).to eq('none')
    end
  end

  describe 'decides if a away goal was scored' do
    let(:team1) { { team: '1', defense: 200, midfield: 250, attack: 100 } }
    let(:team2) { { team: '2', defense: 250, midfield: 200, attack: 150 } }
    let(:selection_match) { [team1, team2] }

    minute_by_minute_target = { minute: 1, chance_on_target: 'away' }

    it 'return that the goal was scored' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)

      chance = Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, selection_match).call

      expect(chance[:goal_scored]).to eq('away')
    end

    it 'return that the goal was not on scored' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(90)

      chance = Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, selection_match).call

      expect(chance[:goal_scored]).to eq('none')
    end
  end
end
