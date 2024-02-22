require 'rails_helper'
require 'pry'

RSpec.describe Match::SquadCreator, type: :model do
  describe "#call" do
    let(:fixture) do
      {
        id: 1,
        club_home: 1,
        club_away: 2,
        week_number: 1,
        competition: "Premier League"
      }
    end

    it "Selection and tactics exist so creates match info and match squad" do
      create(:club, id: 1)
      create(:tactic, club_id: 1, tactics: 3)
      (1..11).each do |n|
        create(:player, id: n, club_id: 1)
      end
      (1..11).each do |player_id|
        Selection.create(player_id:, club_id: 1)
      end

      create(:club, id: 2)
      create(:tactic, club_id: 2, tactics: 3)
      (12..22).each do |n|
        create(:player, id: n, club_id: 2)
      end
      (12..22).each do |player_id|
        Selection.create(player_id:, club_id: 2)
      end

      match_info, match_squad = Match::SquadCreator.new(fixture).call

      # specific expectations as it is an important test
      expect(match_info[:id]).to eq(1)
      expect(match_info[:week]).to eq(1)
      expect(match_info[:competition]).to eq('Premier League')
      expect(match_info[:club_home]).to eq(1)
      expect(match_info[:tactic_home]).to eq(3)
      expect(match_info[:dfc_aggression_home]).to eq(6)
      expect(match_info[:mid_aggression_home]).to eq(6)
      expect(match_info[:att_aggression_home]).to eq(6)
      expect(match_info[:home_press]).to eq(6)
      expect(match_info[:club_away]).to eq(2)
      expect(match_info[:tactic_away]).to eq(3)
      expect(match_info[:dfc_aggression_away]).to eq(6)
      expect(match_info[:mid_aggression_away]).to eq(6)
      expect(match_info[:att_aggression_away]).to eq(6)
      expect(match_info[:away_press]).to eq(6)

      expect(Selection.all.size).to eq(22)

      expect(match_squad).to all(be_a(Player))
      expect(match_squad.count { |player| player.club_id == 1 }).to eq(11)
      expect(match_squad.count { |player| player.club_id == 2 }).to eq(11)
      expect(match_squad.size).to eq(22)
    end

    it "Selection exists and tactics do not exist so creates match info and match squad" do
      create(:club, id: 1)
      (1..11).each do |n|
        create(:player, id: n, club_id: 1)
      end
      (1..11).each do |player_id|
        Selection.create(player_id:, club_id: 1)
      end

      create(:club, id: 2)
      (12..22).each do |n|
        create(:player, id: n, club_id: 2)
      end
      (12..22).each do |player_id|
        Selection.create(player_id:, club_id: 2)
      end

      match_info, match_squad = Match::SquadCreator.new(fixture).call

      # specific expectations as it is an important test
      expect(match_info[:id]).to eq(1)
      expect(match_info[:week]).to eq(1)
      expect(match_info[:competition]).to eq('Premier League')
      expect(match_info[:club_home]).to eq(1)
      expect(match_info[:tactic_home]).to eq(1)
      expect(match_info[:dfc_aggression_home]).to eq(0)
      expect(match_info[:mid_aggression_home]).to eq(0)
      expect(match_info[:att_aggression_home]).to eq(0)
      expect(match_info[:home_press]).to eq(3)
      expect(match_info[:club_away]).to eq(2)
      expect(match_info[:tactic_away]).to eq(1)
      expect(match_info[:dfc_aggression_away]).to eq(0)
      expect(match_info[:mid_aggression_away]).to eq(0)
      expect(match_info[:att_aggression_away]).to eq(0)
      expect(match_info[:away_press]).to eq(3)

      expect(Selection.all.size).to eq(22)

      expect(match_squad).to all(be_a(Player))
      expect(match_squad.count { |player| player.club_id == 1 }).to eq(11)
      expect(match_squad.count { |player| player.club_id == 2 }).to eq(11)
      expect(match_squad.size).to eq(22)
    end

    it "Selection does not exist and tactics exist so raises an error" do
      expect { Match::SquadCreator.new(fixture).call }.to raise_error(StandardError)
    end

    it "Selection less than 11 players and tactics do not exist so raises an error" do
      create(:club, id: 1)
      (1..5).each do |n|
        create(:player, id: n, club_id: 1)
      end
      (1..5).each do |player_id|
        Selection.create(player_id:, club_id: 1)
      end

      create(:club, id: 2)
      (12..16).each do |n|
        create(:player, id: n, club_id: 2)
      end
      (12..16).each do |player_id|
        Selection.create(player_id:, club_id: 2)
      end

      expect { Match::SquadCreator.new(fixture).call }.to raise_error(StandardError)
    end

    it "Selection exists but it does not have player_ids recorded so raises an error" do
      create(:club, id: 1)
      (1..11).each do |n|
        create(:player, id: n, club_id: 1)
      end
      (1..11).each do |player_id|
        Selection.create(club_id: 1)
      end

      create(:club, id: 2)
      (12..22).each do |n|
        create(:player, id: n, club_id: 2)
      end
      (12..22).each do |player_id|
        Selection.create(club_id: 2)
      end

      expect { Match::SquadCreator.new(fixture).call }.to raise_error(StandardError)
    end
  end
end
