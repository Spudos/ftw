require 'test_helper'

class MatchesMinByMinHelperTest < ActionView::TestCase
  include MatchesMinByMinHelper

  def setup
    @home_mod = 10
    @away_mod = 5
    @chance_res = ''
    @chance_count_home = 0
    @chance_count_away = 0
    @chance_on_target = ''
    @chance_on_target_home = 0
    @chance_on_target_away = 0
    @goal_scored = ''
    @goal_home = 0
    @goal_away = 0
    @sqd_pl_home = [
      { id: 1, id: 1, :position 'gkp', match_performance: 7 },
      { id: 2, id: 1, :position 'def', match_performance: 8 },
      { id: 3, id: 1, :position 'mid', match_performance: 9 },
      { id: 4, id: 1, :position 'fwd', match_performance: 10 }
    ]
    @sqd_pl_away = [
      { id: 5, id: 1, :position 'gkp', match_performance: 7 },
      { id: 6, id: 1, :position 'def', match_performance: 8 },
      { id: 7, id: 1, :position 'mid', match_performance: 9 },
      { id: 8, id: 1, :position 'fwd', match_performance: 10 }
    ]
  end

  def test_chance?
    srand(1) # Set random seed for consistent results
    assert_equal 'home', cha?
    srand(2)
    assert_equal 'away', cha?
    srand(3)
    assert_equal 'none', cha?
  end

  def test_add_rand_cha
    srand(1)
    assert_equal 'home', add_rand_cha
    srand(2)
    assert_equal 'away', add_rand_cha
    srand(3)
    assert_equal 'none', add_rand_cha
  end

  def test_chance_count
    @chance_res = 'home'
    chance_count
    assert_equal 1, @chance_count_home
    assert_equal 0, @chance_count_away

    @chance_res = 'away'
    chance_count
    assert_equal 1, @chance_count_away
    assert_equal 0, @chance_count_home
  end

  def test_chance_on_target
    srand(1)
    @chance_res = 'home'
    chance_on_target(80, 70)
    assert_equal 'home', @chance_on_target
    assert_equal 1, @chance_on_target_home
    assert_equal 0, @chance_on_target_away

    srand(2)
    @chance_res = 'away'
    chance_on_target(80, 70)
    assert_equal 'away', @chance_on_target
    assert_equal 0, @chance_on_target_home
    assert_equal 1, @chance_on_target_away

    srand(3)
    @chance_res = 'none'
    chance_on_target(80, 70)
    assert_equal 'none', @chance_on_target
    assert_equal 0, @chance_on_target_home
    assert_equal 0, @chance_on_target_away
  end

  def test_goal_scored?
    srand(1)
    @chance_on_target = 'home'
    goal_scored?(80, 70, 1)
    assert_equal 'home goal', @goal_scored
    assert_equal 1, @goal_home
    assert_equal 0, @goal_away

    srand(2)
    @chance_on_target = 'away'
    goal_scored?(80, 70, 1)
    assert_equal 'away goal', @goal_scored
    assert_equal 0, @goal_home
    assert_equal 1, @goal_away

    srand(3)
    @chance_on_target = 'none'
    goal_scored?(80, 70, 1)
    assert_equal 'no', @goal_scored
    assert_equal 0, @goal_home
    assert_equal 0, @goal_away
  end

  def test_assist_and_scorer
    srand(1)
    expected_goal = { scorer: 4, assist: 3, time: 1 }
    expected_player_statistics = {
      1 => { goals: 0, assists: 0, time: 1, id: 1 },
      2 => { goals: 0, assists: 0, time: 1, id: 1 },
      3 => { goals: 0, assists: 1, time: 1, id: 1 },
      4 => { goals: 1, assists: 0, time: 1, id: 1 }
    }
    assert_equal({ goal: expected_goal, player_statistics: expected_player_statistics }, assist_and_scorer(@sqd_pl_home, 1))

    srand(2)
    expected_goal = { scorer: 8, assist: 7, time: 1 }
    expected_player_statistics = {
      5 => { goals: 0, assists: 0, time: 1, id: 1 },
      6 => { goals: 0, assists: 0, time: 1, id: 1 },
      7 => { goals: 0, assists: 1, time: 1, id: 1 },
      8 => { goals: 1, assists: 0, time: 1, id: 1 }
    }
    assert_equal({ goal: expected_goal, player_statistics: expected_player_statistics }, assist_and_scorer(@sqd_pl_away, 1))
  end
end