require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinuteTarget, type: :model do
  describe 'decides if a chance was on target' do
    let(:team1) { { team: '1', defense_press: 200, midfield_press: 250, attack_press: 100 } }
    let(:team2) { { team: '2', defense_press: 250, midfield_press: 200, attack_press: 150 } }
    let(:selection_match) { [team1, team2] }

    minute_by_minute_chance = { minute: 1, chance_outcome: 'home' }
    midfield_on_attack = 0.5
    target_factor = 60

    it 'return that the chance was on target' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)

      chance = Match::MinuteByMinute::MinuteByMinuteTarget.new(minute_by_minute_chance, selection_match, midfield_on_attack, target_factor).call

      expect(chance[:chance_on_target]).to eq('home')
    end

    it 'return that the chance was not on target' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(90)

      chance = Match::MinuteByMinute::MinuteByMinuteTarget.new(minute_by_minute_chance, selection_match, midfield_on_attack, target_factor).call

      expect(chance[:chance_on_target]).to eq('none')
    end
  end

  describe 'decides if a away chance was on target' do
    let(:team1) { { team: '1', defense_press: 200, midfield_press: 250, attack_press: 100 } }
    let(:team2) { { team: '2', defense_press: 250, midfield_press: 200, attack_press: 150 } }
    let(:selection_match) { [team1, team2] }

    minute_by_minute_chance = { minute: 1, chance_outcome: 'away' }
    midfield_on_attack = 0.5
    target_factor = 60

    it 'return that the chance was on target' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)

      chance = Match::MinuteByMinute::MinuteByMinuteTarget.new(minute_by_minute_chance, selection_match, midfield_on_attack, target_factor).call

      expect(chance[:chance_on_target]).to eq('away')
    end

    it 'return that the chance was not on target' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(90)

      chance = Match::MinuteByMinute::MinuteByMinuteTarget.new(minute_by_minute_chance, selection_match, midfield_on_attack, target_factor).call

      expect(chance[:chance_on_target]).to eq('none')
    end
  end
end
