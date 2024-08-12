require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinuteChance, type: :model do
  describe 'decides if a home chance was created' do
    let(:team1) { { team: '1', defense_press: 200, midfield_press: 250, attack_press: 100 } }
    let(:team2) { { team: '2', defense_press: 250, midfield_press: 200, attack_press: 150 } }
    let(:minute_by_minute_press) { [team1, team2] }

    i = 1

    it 'return that the team created a chance based on midfield values' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(50)

      chance = Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i).call

      expect(chance[:chance_outcome]).to eq('home')
    end

    it 'return that the team created a random chance' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(50)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(3)

      chance = Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i).call

      expect(chance[:chance_outcome]).to eq('home')
    end

    it 'return that no team created a chance' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(50)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(50)

      chance = Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i).call

      expect(chance[:chance_outcome]).to eq('none')
    end
  end

  describe 'decides if a away chance was created' do
    let(:team1) { { team: '1', defense_press: 200, midfield_press: 150, attack_press: 100 } }
    let(:team2) { { team: '2', defense_press: 250, midfield_press: 200, attack_press: 150 } }
    let(:minute_by_minute_press) { [team1, team2] }

    i = 1

    it 'return that the team created a chance based on midfield values' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(50)

      chance = Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i).call

      expect(chance[:chance_outcome]).to eq('away')
    end

    it 'return that the team created a random chance' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(50)
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(7)

      chance = Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i).call

      expect(chance[:chance_outcome]).to eq('away')
    end
  end
end
