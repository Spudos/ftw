require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinuteScored, type: :model do
  describe 'decides if a home goal was scored' do
    let(:team1) { { team: '1', defense_press: 200, midfield_press: 250, attack_press: 100 } }
    let(:team2) { { team: '2', defense_press: 250, midfield_press: 200, attack_press: 150 } }
    let(:selection_match) { [team1, team2] }

    minute_by_minute_target = { minute: 1, chance_on_target: 'home' }
    goal_factor = 40

    it 'return that the goal was scored' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)

      chance = Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, selection_match, goal_factor).call

      expect(chance[:goal_scored]).to eq('home')
    end

    it 'return that the goal was not scored' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(90)

      chance = Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, selection_match, goal_factor).call

      expect(chance[:goal_scored]).to eq('none')
    end
  end

  describe 'decides if a away goal was scored' do
    let(:team1) { { team: '1', defense_press: 200, midfield_press: 250, attack_press: 100 } }
    let(:team2) { { team: '2', defense_press: 250, midfield_press: 200, attack_press: 150 } }
    let(:selection_match) { [team1, team2] }

    minute_by_minute_target = { minute: 1, chance_on_target: 'away' }
    goal_factor = 40

    it 'return that the goal was scored' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)

      chance = Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, selection_match, goal_factor).call

      expect(chance[:goal_scored]).to eq('away')
    end

    it 'return that the goal was not on scored' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(90)

      chance = Match::MinuteByMinute::MinuteByMinuteScored.new(minute_by_minute_target, selection_match, goal_factor).call

      expect(chance[:goal_scored]).to eq('none')
    end
  end
end
