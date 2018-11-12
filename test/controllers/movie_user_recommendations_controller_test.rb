require 'test_helper'

class MovieUserRecommendationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie_user_recommendation = movie_user_recommendations(:one)
  end

  test "should get index" do
    get movie_user_recommendations_url
    assert_response :success
  end

  test "should get new" do
    get new_movie_user_recommendation_url
    assert_response :success
  end

  test "should create movie_user_recommendation" do
    assert_difference('MovieUserRecommendation.count') do
      post movie_user_recommendations_url, params: { movie_user_recommendation: { confidence: @movie_user_recommendation.confidence, movie_id: @movie_user_recommendation.movie_id, user_id: @movie_user_recommendation.user_id, user_rating: @movie_user_recommendation.user_rating } }
    end

    assert_redirected_to movie_user_recommendation_url(MovieUserRecommendation.last)
  end

  test "should show movie_user_recommendation" do
    get movie_user_recommendation_url(@movie_user_recommendation)
    assert_response :success
  end

  test "should get edit" do
    get edit_movie_user_recommendation_url(@movie_user_recommendation)
    assert_response :success
  end

  test "should update movie_user_recommendation" do
    patch movie_user_recommendation_url(@movie_user_recommendation), params: { movie_user_recommendation: { confidence: @movie_user_recommendation.confidence, movie_id: @movie_user_recommendation.movie_id, user_id: @movie_user_recommendation.user_id, user_rating: @movie_user_recommendation.user_rating } }
    assert_redirected_to movie_user_recommendation_url(@movie_user_recommendation)
  end

  test "should destroy movie_user_recommendation" do
    assert_difference('MovieUserRecommendation.count', -1) do
      delete movie_user_recommendation_url(@movie_user_recommendation)
    end

    assert_redirected_to movie_user_recommendations_url
  end
end
