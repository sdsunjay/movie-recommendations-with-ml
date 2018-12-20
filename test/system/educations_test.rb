require "application_system_test_case"

class EducationsTest < ApplicationSystemTestCase
  setup do
    @education = educations(:one)
  end

  test "visiting the index" do
    visit educations_url
    assert_selector "h1", text: "Educations"
  end

  test "creating a Education" do
    visit educations_url
    click_on "New Education"

    fill_in "Abbreviation", with: @education.abbreviation
    fill_in "Address", with: @education.address
    fill_in "City", with: @education.city
    fill_in "Homepage", with: @education.homepage
    fill_in "Name", with: @education.name
    fill_in "State", with: @education.state
    fill_in "Zipcode", with: @education.zipcode
    click_on "Create Education"

    assert_text "Education was successfully created"
    click_on "Back"
  end

  test "updating a Education" do
    visit educations_url
    click_on "Edit", match: :first

    fill_in "Abbreviation", with: @education.abbreviation
    fill_in "Address", with: @education.address
    fill_in "City", with: @education.city
    fill_in "Homepage", with: @education.homepage
    fill_in "Name", with: @education.name
    fill_in "State", with: @education.state
    fill_in "Zipcode", with: @education.zipcode
    click_on "Update Education"

    assert_text "Education was successfully updated"
    click_on "Back"
  end

  test "destroying a Education" do
    visit educations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Education was successfully destroyed"
  end
end
