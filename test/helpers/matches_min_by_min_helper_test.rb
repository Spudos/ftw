require 'test_helper'

class MatchesMinByMinHelperTest < ActionView::TestCase
  include MatchesMinByMinHelper

  def setup
    @hm_mod = 10
    @aw_mod = 5
    @cha_res = ''
    @cha_count_hm = 0
    @cha_count_aw = 0
    @cha_on_tar = ''
    @cha_on_tar_hm = 0
    @cha_on_tar_aw = 0
    @goal_scored = ''
    @goal_hm = 0
    @goal_aw = 0
    @sqd_pl_hm = [
      { id: 1, match_id: 1, pos: 'gkp', match_perf: 7 },
      { id: 2, match_id: 1, pos: 'def', match_perf: 8 },
      { id: 3, match_id: 1, pos: 'mid', match_perf: 9 },
      { id: 4, match_id: 1, pos: 'fwd', match_perf: 10 }
    ]
    @sqd_pl_aw = [
      { id: 5, match_id: 1, pos: 'gkp', match_perf: 7 },
      { id: 6, match_id: 1, pos: 'def', match_perf: 8 },
      { id: 7, match_id: 1, pos: 'mid', match_perf: 9 },
      { id: 8, match_id: 1, pos: 'fwd', match_perf: 10 }
    ]
  end

  def test_cha?
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

  def test_cha_count
    @cha_res = 'home'
    cha_count
    assert_equal 1, @cha_count_hm
    assert_equal 0, @cha_count_aw

    @cha_res = 'away'
    cha_count
    assert_equal 1, @cha_count_aw
    assert_equal 0, @cha_count_hm
  end

  def test_cha_on_tar
    srand(1)
    @cha_res = 'home'
    cha_on_tar(80, 70)
    assert_equal 'home', @cha_on_tar
    assert_equal 1, @cha_on_tar_hm
    assert_equal 0, @cha_on_tar_aw

    srand(2)
    @cha_res = 'away'
    cha_on_tar(80, 70)
    assert_equal 'away', @cha_on_tar
    assert_equal 0, @cha_on_tar_hm
    assert_equal 1, @cha_on_tar_aw

    srand(3)
    @cha_res = 'none'
    cha_on_tar(80, 70)
    assert_equal 'none', @cha_on_tar
    assert_equal 0, @cha_on_tar_hm
    assert_equal 0, @cha_on_tar_aw
  end

  def test_goal_scored?
    srand(1)
    @cha_on_tar = 'home'
    goal_scored?(80, 70, 1)
    assert_equal 'home goal', @goal_scored
    assert_equal 1, @goal_hm
    assert_equal 0, @goal_aw

    srand(2)
    @cha_on_tar = 'away'
    goal_scored?(80, 70, 1)
    assert_equal 'away goal', @goal_scored
    assert_equal 0, @goal_hm
    assert_equal 1, @goal_aw

    srand(3)
    @cha_on_tar = 'none'
    goal_scored?(80, 70, 1)
    assert_equal 'no', @goal_scored
    assert_equal 0, @goal_hm
    assert_equal 0, @goal_aw
  end

  def test_assist_and_scorer
    srand(1)
    expected_goal = { scorer: 4, assist: 3, time: 1 }
    expected_player_stats = {
      1 => { goals: 0, assists: 0, time: 1, match_id: 1 },
      2 => { goals: 0, assists: 0, time: 1, match_id: 1 },
      3 => { goals: 0, assists: 1, time: 1, match_id: 1 },
      4 => { goals: 1, assists: 0, time: 1, match_id: 1 }
    }
    assert_equal({ goal: expected_goal, player_stats: expected_player_stats }, assist_and_scorer(@sqd_pl_hm, 1))

    srand(2)
    expected_goal = { scorer: 8, assist: 7, time: 1 }
    expected_player_stats = {
      5 => { goals: 0, assists: 0, time: 1, match_id: 1 },
      6 => { goals: 0, assists: 0, time: 1, match_id: 1 },
      7 => { goals: 0, assists: 1, time: 1, match_id: 1 },
      8 => { goals: 1, assists: 0, time: 1, match_id: 1 }
    }
    assert_equal({ goal: expected_goal, player_stats: expected_player_stats }, assist_and_scorer(@sqd_pl_aw, 1))
  end
end