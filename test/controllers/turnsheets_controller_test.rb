require "test_helper"

class TurnsheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @turnsheet = turnsheets(:one)
  end

  test "should get index" do
    get turnsheets_url
    assert_response :success
  end

  test "should get new" do
    get new_turnsheet_url
    assert_response :success
  end

  test "should create turnsheet" do
    assert_difference("Turnsheet.count") do
      post turnsheets_url, params: { turnsheet: { club: @turnsheet.club, email: @turnsheet.email, manager: @turnsheet.manager, week: @turnsheet.week } }
    end

    assert_redirected_to turnsheet_url(Turnsheet.last)
  end

  test "should show turnsheet" do
    get turnsheet_url(@turnsheet)
    assert_response :success
  end

  test "should get edit" do
    get edit_turnsheet_url(@turnsheet)
    assert_response :success
  end

  test "should update turnsheet" do
    patch turnsheet_url(@turnsheet), params: { turnsheet: { club: @turnsheet.club, email: @turnsheet.email, manager: @turnsheet.manager, week: @turnsheet.week } }
    assert_redirected_to turnsheet_url(@turnsheet)
  end

  test "should destroy turnsheet" do
    assert_difference("Turnsheet.count", -1) do
      delete turnsheet_url(@turnsheet)
    end

    assert_redirected_to turnsheets_url
  end
end
