require 'rails_helper'
require 'pry'

RSpec.describe Match::InitializePlayer::SelectionStar, type: :model do
  describe 'star effect should amend the performance' do
    it 'should return the performance with star effect of 70' do
      allow_any_instance_of(Kernel).to receive(:rand).with(1..100).and_return(51)

      selection_tactic = [{ club_id: '1', player_id: 1, name: 'woolley',
                            total_skill: 85, position: 'gkp', position_detail: 'p',
                            blend: 5, star: 20, fitness: 90, performance: 50 }]

      selection_star = Match::InitializePlayer::SelectionStar.new(selection_tactic).call

      expect(selection_star[0][:performance]).to eq(70)
    end
  end
end
