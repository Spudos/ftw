require 'rails_helper'

RSpec.describe Player, type: :model do
  describe "perform basic skill calculations" do  
    context "with valid player data" do
      it "should return the base skill of a player" do
        player = build(:player)

        base_skill = player.send(:base_skill)

        expect(base_skill).to be == 55
      end
    end
    context "with invalid player data" do
      it "should not return the base skill of a player" do
        player = build(:player, passing: 'p')

        base_skill = player.send(:base_skill)

        expect(base_skill).to be nil?
      end
    end
    context "if the player does not exist" do
      it "should not return the base skill of a player" do
        player = []

        base_skill = player.send(:base_skill)

        expect(base_skill).to be nil?
      end
    end
  end

  describe "perform total skill calculations" do  
    context "with valid player data" do
      it "should return the total skill of a gkp" do
        player = build(:player)

        total_skill = player.send(:total_skill)

        expect(total_skill).to be == 85
      end

      it "should return the total skill of a dfc" do
        player = build(:player, position: 'dfc')

        total_skill = player.send(:total_skill)

        expect(total_skill).to be == 85
      end

      it "should return the total skill of a mid" do
        player = build(:player, position: 'mid')

        total_skill = player.send(:total_skill)

        expect(total_skill).to be == 85
      end

      it "should return the total skill of a att" do
        player = build(:player, position: 'att')

        total_skill = player.send(:total_skill)

        expect(total_skill).to be == 85
      end
    end
    context "with invalid player data" do
      it "should not return the total skill of a atm" do
        player = build(:player, position: 'atm')

        total_skill = player.send(:total_skill)

        expect(total_skill).to be nil?
      end
    end
  end

  describe "calculate match perfromance" do
    context "with valid parameters" do
      it "should return the correct match performance for a gkp" do
        player = build(:player)

        match_performance = player.send(:match_performance, player)
        # 6 core skills * 5 from player model = 30.  fitness 90 to give 27, consistency +-10 so 17 to 37
        expect(match_performance).to be_between(17, 37).inclusive
      end
    end
  end
end
