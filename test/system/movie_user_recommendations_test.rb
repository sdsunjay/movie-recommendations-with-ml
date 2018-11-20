require "application_system_test_case"

class MovieUserRecommendationsTest < ApplicationSystemTestCase
  setup do
    @movie_user_recommendation = movie_user_recommendations(:one)
  end

  test "visiting the index" do
    visit movie_user_recommendations_url
    assert_selector "h1", text: "Movie User Recommendations"
  end

  test "creating a Movie user recommendation" do
    visit movie_user_recommendations_url
    click_on "New Movie User Recommendation"

    fill_in "Confidence", with: @movie_user_recommendation.confidence
    fill_in "Movie", with: @movie_user_recommendation.movie_id
    fill_in "User", with: @movie_user_recommendation.user_id
    fill_in "User Rating", with: @movie_user_recommendation.user_rating
    click_on "Create Movie user recommendation"

    assert_text "Movie user recommendation was successfully created"
    click_on "Back"
  end

  test "updating a Movie user recommendation" do
    visit movie_user_recommendations_url
    click_on "Edit", match: :first

    fill_in "Confidence", with: @movie_user_recommendation.confidence
    fill_in "Movie", with: @movie_user_recommendation.movie_id
    fill_in "User", with: @movie_user_recommendation.user_id
    fill_in "User Rating", with: @movie_user_recommendation.user_rating
    click_on "Update Movie user recommendation"

    assert_text "Movie user recommendation was successfully updated"
    click_on "Back"
  end

  test "destroying a Movie user recommendation" do
    visit movie_user_recommendations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Movie user recommendation was successfully destroyed"
  end
end
