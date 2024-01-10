require 'test_helper'

class MatchesSquadHelperTest < ActionView::TestCase
  include MatchesSquadHelper

  def setup
    @match_id = 1
  end

  def test_squad_pl
    player1 = Player.new(id: 1, club: 'ABC', name: 'Player 1', pos: 'gkp', total_skill: 80)
    player2 = Player.new(id: 2, club: 'XYZ', name: 'Player 2', pos: 'def', total_skill: 70)
    sqd = [player1, player2]

    expected_result = [
      {
        match_id: @match_id,
        id: player1.id,
        club: player1.club,
        name: player1.name,
        pos: player1.pos,
        total_skill: player1.total_skill,
        match_performance: player1.match_performance(player1)
      },
      {
        match_id: @match_id,
        id: player2.id,
        club: player2.club,
        name: player2.name,
        pos: player2.pos,
        total_skill: player2.total_skill,
        match_performance: player2.match_performance(player2)
      }
    ]

    assert_equal expected_result, sqd_pl(sqd)
  end

  # Add more test cases for other scenarios...

end