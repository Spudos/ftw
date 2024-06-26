require 'rails_helper'
require 'pry'

RSpec.describe Match::AggressionEffect, type: :model do
  describe 'totals with aggression' do
    let(:team1) { { team: 1, defense: 200, midfield: 150, attack: 100 } }
    let(:team2) { { team: 2, defense: 250, midfield: 200, attack: 150 } }
    let(:totals_stadium) { [team1, team2] }

    let(:tactic1) { double('Tactic', club_id: 1, dfc_aggression: 2, mid_aggression: 3, att_aggression: 4) }
    let(:tactic2) { double('Tactic', club_id: 2, dfc_aggression: 1, mid_aggression: 2, att_aggression: 3) }

    before do
      allow(Tactic).to receive(:find_by).with(club_id: 1).and_return(tactic1)
      allow(Tactic).to receive(:find_by).with(club_id: 2).and_return(tactic2)
    end

    it 'returns the totals with aggression' do
      expected_totals_aggression = [
        { team: 1, defense: 210, midfield: 165, attack: 120 },
        { team: 2, defense: 255, midfield: 210, attack: 165 },
          ]

      totals_aggression = Match::AggressionEffect.new(totals_stadium).call

      expect(totals_aggression).to eq(expected_totals_aggression)
    end
  end
end