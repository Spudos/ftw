require "application_system_test_case"

class SelectionsTest < ApplicationSystemTestCase
  setup do
    @selection = selections(:one)
  end

  test "visiting the index" do
    visit selections_url
    assert_selector "h1", text: "Selections"
  end

  test "should create selection" do
    visit selections_url
    click_on "New selection"

    fill_in "Club", with: @selection.club
    fill_in "Player", with: @selection.player_id
    click_on "Create Selection"

    assert_text "Selection was successfully created"
    click_on "Back"
  end

  test "should update Selection" do
    visit selection_url(@selection)
    click_on "Edit this selection", match: :first

    fill_in "Club", with: @selection.club
    fill_in "Player", with: @selection.player_id
    click_on "Update Selection"

    assert_text "Selection was successfully updated"
    click_on "Back"
  end

  test "should destroy Selection" do
    visit selection_url(@selection)
    click_on "Destroy this selection", match: :first

    assert_text "Selection was successfully destroyed"
  end
end
