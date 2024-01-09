require 'test_helper'

class MatchesInitializersHelperTest < ActionView::TestCase
  include MatchesInitializersHelper

  def setup
    @club_hm = 'ABC'
    @club_aw = 'XYZ'
    @goal = { scorer: 1, assist: 2 }
    @goal_scored = 'home goal'
    @cha_res = 'home'
    @cha_on_tar = 'home'
    @sqd_hm = [Player.new(name: 'Player 1', pos: 'gkp'), Player.new(name: 'Player 2', pos: 'def')]
    @sqd_aw = [Player.new(name: 'Player 3', pos: 'gkp'), Player.new(name: 'Player 4', pos: 'def')]
  end

  def test_initialize_commentary_home_goal
    Club.stub(:find_by, Club.new(name: 'Home Club')) do
      Player.stub(:find_by, Player.new(name: 'Scorer')) do
        Player.stub(:find_by, Player.new(name: 'Assister')) do
          Template.stub(:random_match_goal_commentary, 'Goal scored by {scorer} for {team}!') do
            assert_equal 'Goal scored by Scorer for Home Club!', initialize_commentary
          end
        end
      end
    end
  end

  def test_initialize_commentary_away_goal
    Club.stub(:find_by, Club.new(name: 'Away Club')) do
      Player.stub(:find_by, Player.new(name: 'Scorer')) do
        Player.stub(:find_by, Player.new(name: 'Assister')) do
          Template.stub(:random_match_goal_commentary, 'Goal scored by {scorer} for {team}!') do
            assert_equal 'Goal scored by Scorer for Away Club!', initialize_commentary
          end
        end
      end
    end
  end
end
