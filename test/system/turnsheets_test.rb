require "application_system_test_case"

class TurnsheetsTest < ApplicationSystemTestCase
  setup do
    @turnsheet = turnsheets(:one)
  end

  test "visiting the index" do
    visit turnsheets_url
    assert_selector "h1", text: "Turnsheets"
  end

  test "should create turnsheet" do
    visit turnsheets_url
    click_on "New turnsheet"

    fill_in "Club", with: @turnsheet.club
    fill_in "Email", with: @turnsheet.email
    fill_in "Manager", with: @turnsheet.manager
    fill_in "Week", with: @turnsheet.week
    click_on "Create Turnsheet"

    assert_text "Turnsheet was successfully created"
    click_on "Back"
  end

  test "should update Turnsheet" do
    visit turnsheet_url(@turnsheet)
    click_on "Edit this turnsheet", match: :first

    fill_in "Club", with: @turnsheet.club
    fill_in "Email", with: @turnsheet.email
    fill_in "Manager", with: @turnsheet.manager
    fill_in "Week", with: @turnsheet.week
    click_on "Update Turnsheet"

    assert_text "Turnsheet was successfully updated"
    click_on "Back"
  end

  test "should destroy Turnsheet" do
    visit turnsheet_url(@turnsheet)
    click_on "Destroy this turnsheet", match: :first

    assert_text "Turnsheet was successfully destroyed"
  end
end
