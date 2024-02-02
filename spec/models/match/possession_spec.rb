require 'rails_helper'
require 'pry'

RSpec.describe Match::Possession, type: :model do
  describe 'where chances are equal' do
    it 'should return the possession for each side' do
      match_summary = { chance_count_home: 1, chance_count_away: 1 }

      possession = Match::Possession.new(match_summary).call

      expect(possession[:home_possession]).to be == 60
      expect(possession[:away_possession]).to be == 40
    end
  end

  describe 'where chances are in favour of the home side' do
    it 'should return the possession for each side' do
      allow_any_instance_of(Kernel).to receive(:rand).with(20..30).and_return(25)

      match_summary = { chance_count_home: 20, chance_count_away: 1 }

      possession = Match::Possession.new(match_summary).call

      expect(possession[:home_possession]).to be == 75
      expect(possession[:away_possession]).to be == 25
    end
  end

  describe 'where chances are in favour of the away side' do
    it 'should return the possession for each side' do
      match_summary = { chance_count_home: 1, chance_count_away: 30 }

      possession = Match::Possession.new(match_summary).call

      expect(possession[:home_possession]).to be == 23
      expect(possession[:away_possession]).to be == 77
    end
  end

  describe 'where there are no chances for the home side' do
    it 'should return the possession for each side' do
      match_summary = { chance_count_home: 0, chance_count_away: 30 }

      possession = Match::Possession.new(match_summary).call

      expect(possession[:home_possession]).to be == 20
      expect(possession[:away_possession]).to be == 80
    end
  end

  describe 'where there are no chances for the away side' do
    it 'should return the possession for each side' do
      allow_any_instance_of(Kernel).to receive(:rand).with(20..30).and_return(22)

      match_summary = { chance_count_home: 20, chance_count_away: 0 }

      possession = Match::Possession.new(match_summary).call

      expect(possession[:home_possession]).to be == 78
      expect(possession[:away_possession]).to be == 22
    end
  end

  describe 'where there are no chances for the either side' do
    it 'should return the possession for each side' do
      allow_any_instance_of(Kernel).to receive(:rand).with(20..30).and_return(22)

      match_summary = { chance_count_home: 0, chance_count_away: 0 }

      possession = Match::Possession.new(match_summary).call

      expect(possession[:home_possession]).to be == 52
      expect(possession[:away_possession]).to be == 48
    end
  end
end