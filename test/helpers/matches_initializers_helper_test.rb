require 'test_helper'

class MatchesInitializersHelperTest < ActionView::TestCase
  include MatchesInitializersHelper

  def setup
    @club_home = 'ABC'
    @club_awayay = 'XYZ'
    @goal = { scorer: 1, assist: 2 }
    @goal_scored = 'home goal'
    @chance_res = 'home'
    @chance_on_target = 'home'
    @sqd_home = [Player.new(name: 'Player 1', :position 'gkp'), Player.new(name: 'Player 2', :position 'def')]
    @sqd_away = [Player.new(name: 'Player 3', :position 'gkp'), Player.new(name: 'Player 4', :position 'def')]
  end

  def test_initialize_commentary_home_goals
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

  def test_initialize_commentary_awayay_goals
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
