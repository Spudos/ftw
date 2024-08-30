require 'rails_helper'
require 'pry'

RSpec.describe Match::MinuteByMinute::MinuteByMinuteChance, type: :model do
  describe 'decides chance was created' do
    let(:team1) { { team: '1', defense_press: 200, midfield_press: 250, attack_press: 100 } }
    let(:team2) { { team: '2', defense_press: 250, midfield_press: 200, attack_press: 150 } }
    let(:minute_by_minute_press) { [team1, team2] }

    chance_factor = 3
    i = 1

    it 'return that the home team created a chance based on team values' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(10)

      chance = Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i, chance_factor).call

      expect(chance[:chance_outcome]).to eq('home')
    end

    it 'return that the away team created a chance based on team values' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(30)

      chance = Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i, chance_factor).call

      expect(chance[:chance_outcome]).to eq('away')
    end

    it 'return that no team created a chance' do
      allow_any_instance_of(Kernel).to receive(:rand).with(0..100).and_return(75)

      chance = Match::MinuteByMinute::MinuteByMinuteChance.new(minute_by_minute_press, i, chance_factor).call

      expect(chance[:chance_outcome]).to eq('none')
    end
  end
end
