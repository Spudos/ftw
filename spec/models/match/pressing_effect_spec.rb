require 'rails_helper'
require 'pry'

RSpec.describe Match::PressingEffect, type: :model do
  describe 'calculate match_squad totals with positive press values' do
    let(:team1) { { team: '001', defense: 200, midfield: 150, attack: 100 } }
    let(:team2) { { team: '002', defense: 250, midfield: 200, attack: 150 } }
    let(:final_squad) { [team1, team2] }

    let(:tactic1) { double('Tactic', club_id: '001', press: 1) }
    let(:tactic2) { double('Tactic', club_id: '002', press: 2) }

    before do
      allow(Tactic).to receive(:find_by).with(club_id: '001').and_return(tactic1)
      allow(Tactic).to receive(:find_by).with(club_id: '002').and_return(tactic2)
    end

    it 'based on a press of 1 for the home side and 2 for the away side in the 9th minute' do
      i = 9

      expected_match_squad = [
        { team: '001', defense: 200, midfield: 156, attack: 106 },
        { team: '002', defense: 250, midfield: 212, attack: 162 },
      ]

      match_squad = Match::PressingEffect.new(final_squad, i).call

      expect(match_squad).to eq(expected_match_squad)
    end

    it 'based on a press of 1 for the home side and 2 for the away side in the 49th minute' do
      i = 49

      expected_match_squad = [
        { team: '001', defense: 200, midfield: 152, attack: 102 },
        { team: '002', defense: 250, midfield: 204, attack: 154 },
      ]

      match_squad = Match::PressingEffect.new(final_squad, i).call

      expect(match_squad).to eq(expected_match_squad)
    end

    it 'based on a press of 1 for the home side and 2 for the away side in the 89th minute' do
      i = 89

      expected_match_squad = [
        { team: '001', defense: 200, midfield: 146, attack: 96 },
        { team: '002', defense: 250, midfield: 192, attack: 142 },
      ]

      match_squad = Match::PressingEffect.new(final_squad, i).call

      expect(match_squad).to eq(expected_match_squad)
    end
  end

  describe 'calculate match_squad totals with positive press values' do
    let(:team1) { { team: '001', defense: 200, midfield: 150, attack: 100 } }
    let(:team2) { { team: '002', defense: 250, midfield: 200, attack: 150 } }
    let(:final_squad) { [team1, team2] }

    let(:tactic1) { double('Tactic', club_id: '001', press: -1) }
    let(:tactic2) { double('Tactic', club_id: '002', press: -2) }

    before do
      allow(Tactic).to receive(:find_by).with(club_id: '001').and_return(tactic1)
      allow(Tactic).to receive(:find_by).with(club_id: '002').and_return(tactic2)
    end

    it 'based on a press of -1 for the home side and -2 for the away side in the 9th minute' do
      i = 9

      expected_match_squad = [
        { team: '001', defense: 200, midfield: 144, attack: 94 },
        { team: '002', defense: 250, midfield: 188, attack: 138 },
      ]

      match_squad = Match::PressingEffect.new(final_squad, i).call

      expect(match_squad).to eq(expected_match_squad)
    end

    it 'based on a press of -1 for the home side and -2 for the away side in the 49th minute' do
      i = 49

      expected_match_squad = [
        { team: '001', defense: 200, midfield: 148, attack: 98 },
        { team: '002', defense: 250, midfield: 196, attack: 146 },
      ]

      match_squad = Match::PressingEffect.new(final_squad, i).call

      expect(match_squad).to eq(expected_match_squad)
    end

    it 'based on a press of -1 for the home side and -2 for the away side in the 89th minute' do
      i = 89

      expected_match_squad = [
        { team: '001', defense: 200, midfield: 154, attack: 104 },
        { team: '002', defense: 250, midfield: 208, attack: 158 },
      ]

      match_squad = Match::PressingEffect.new(final_squad, i).call

      expect(match_squad).to eq(expected_match_squad)
    end
  end

  describe 'calculate match_squad totals with no press set' do
    let(:team1) { { team: '001', defense: 200, midfield: 150, attack: 100 } }
    let(:team2) { { team: '002', defense: 250, midfield: 200, attack: 150 } }
    let(:final_squad) { [team1, team2] }

    let(:tactic1) { double('Tactic', club_id: '001', press: nil) }
    let(:tactic2) { double('Tactic', club_id: '002', press: nil) }

    before do
      allow(Tactic).to receive(:find_by).with(club_id: '001').and_return(tactic1)
      allow(Tactic).to receive(:find_by).with(club_id: '002').and_return(tactic2)
    end

    it 'based on a press of null for the home side and null for the away side in the 9th minute' do
      i = 9

      expected_match_squad = [
        { team: '001', defense: 200, midfield: 150, attack: 100 },
        { team: '002', defense: 250, midfield: 200, attack: 150 },
      ]

      match_squad = Match::PressingEffect.new(final_squad, i).call

      expect(match_squad).to eq(expected_match_squad)
    end
  end

  describe 'calculate match_squad totals with no tactic set' do
    let(:team1) { { team: '001', defense: 200, midfield: 150, attack: 100 } }
    let(:team2) { { team: '002', defense: 250, midfield: 200, attack: 150 } }
    let(:final_squad) { [team1, team2] }

    it 'based on a press of null for the home side and null for the away side in the 9th minute' do
      i = 9

      expected_match_squad = [
        { team: '001', defense: 200, midfield: 150, attack: 100 },
        { team: '002', defense: 250, midfield: 200, attack: 150 },
      ]

      match_squad = Match::PressingEffect.new(final_squad, i).call

      expect(match_squad).to eq(expected_match_squad)
    end
  end
end
