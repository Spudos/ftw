require 'rails_helper'
require 'pry'

RSpec.describe Match::SquadCreator, type: :model do
  let(:fixture) do
    {
      id: 1,
      club_home: "001",
      club_away: "002",
      week_number: 1,
      competition: "Premier League"
    }
  end

  let(:players) {
    FactoryBot.create_list(:player, 22)
  }

  describe "#call" do
    it "returns match_info and match_squad" do
      match_info, match_squad = Match::SquadCreator.new(fixture).call

      expect(match_info).to be_a(Hash)
      expect(match_squad).to be_an(Array)
    end
  end

  describe "#populate_teams" do
    it "returns an array of player_ids" do
      squad_creator = Match::SquadCreator.new(fixture)

      player_ids = squad_creator.send(:populate_teams)

      expect(player_ids).to be_an(Array)
      expect(player_ids).to all(be_an(Integer))
    end
  end

  describe "#match_squad" do
    it "returns an array of players" do
      squad_creator = Match::SquadCreator.new(fixture)

      match_squad = squad_creator.send(:match_squad)

      expect(match_squad).to be_an(Array)
      expect(match_squad).to all(be_a(Player))
    end
  end

  describe "#match_info" do
    it "returns a hash of match information" do
      squad_creator = Match::SquadCreator.new(fixture)

      match_info = squad_creator.send(:match_info)

      expect(match_info).to be_a(Hash)
      expect(match_info).to include(:id, :week, :competition, :club_home, :club_away)
    end
  end
end
