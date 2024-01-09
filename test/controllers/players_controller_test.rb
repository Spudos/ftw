require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  def setup
    @player1 = Player.create(name: 'Player 1', age: 25, position: 'Forward')
    @player2 = Player.create(name: 'Player 2', age: 28, position: 'Midfielder')
    @player3 = Player.create(name: 'Player 3', age: 23, position: 'Defender')
  end

  test 'should get show' do
    get :show
    assert_response :success
    assert_not_nil assigns(:players)
  end

  test 'should sort players by column in ascending order' do
    get :show, params: { sort_column: 'name', sort_direction: 'asc', sort_criteria: '' }
    assert_response :success
    assert_equal [@player1, @player2, @player3], assigns(:sorted)
  end

  test 'should sort players by column in descending order' do
    get :show, params: { sort_column: 'age', sort_direction: 'desc', sort_criteria: '' }
    assert_response :success
    assert_equal [@player2, @player1, @player3], assigns(:sorted)
  end

  test 'should filter players by criteria' do
    get :show, params: { sort_column: 'position', sort_direction: 'asc', sort_criteria: 'Forward' }
    assert_response :success
    assert_equal [@player1], assigns(:sorted)
  end
end