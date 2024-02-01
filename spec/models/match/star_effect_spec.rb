require 'rails_helper'
require 'pry'

RSpec.describe Match::StarEffect, type: :model do
  describe 'star effect should amend the performance' do
    it 'should return the performance with star effect of 70' do
      allow_any_instance_of(Kernel).to receive(:rand).with(100).and_return(51)
      squads_with_tactics = [
        {
          match_performance: 50,
          star: 20
        }
      ]
      adjusted_player = Match::StarEffect.new(squads_with_tactics).call

      expect(adjusted_player[0][:match_performance]).to eq(70)
    end
    it 'should return the performance without star effect of 50' do
      allow_any_instance_of(Kernel).to receive(:rand).with(100).and_return(49)
      squads_with_tactics = [
        {
          match_performance: 50,
          star: 20
        }
      ]
      adjusted_player = Match::StarEffect.new(squads_with_tactics).call

      expect(adjusted_player[0][:match_performance]).to eq(50)
    end
    it 'should return the performance of 20 to 30' do
      squads_with_tactics = [
        {
          match_performance: 10,
          star: 0
        }
      ]
      adjusted_player = Match::StarEffect.new(squads_with_tactics).call

      expect(adjusted_player[0][:match_performance]).to be_between(20, 30).inclusive
    end
  end
end
