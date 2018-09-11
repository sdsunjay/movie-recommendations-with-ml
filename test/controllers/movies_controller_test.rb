require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = movies(:one)
  end

  test "should get index" do
    get movies_url
    assert_response :success
  end

  test "should get new" do
    get new_movie_url
    assert_response :success
  end

  test "should create movie" do
    assert_difference('Movie.count') do
      post movies_url, params: { movie: { budget: @movie.budget, genre_id: @movie.genre_id, imdb_id: @movie.imdb_id, overview: @movie.overview, popularity: @movie.popularity, poster_path: @movie.poster_path, release_date: @movie.release_date, revenue: @movie.revenue, runtime: @movie.runtime, status: @movie.status, tagline: @movie.tagline, title: @movie.title } }
    end

    assert_redirected_to movie_url(Movie.last)
  end

  test "should show movie" do
    get movie_url(@movie)
    assert_response :success
  end

  test "should get edit" do
    get edit_movie_url(@movie)
    assert_response :success
  end

  test "should update movie" do
    patch movie_url(@movie), params: { movie: { budget: @movie.budget, genre_id: @movie.genre_id, imdb_id: @movie.imdb_id, overview: @movie.overview, popularity: @movie.popularity, poster_path: @movie.poster_path, release_date: @movie.release_date, revenue: @movie.revenue, runtime: @movie.runtime, status: @movie.status, tagline: @movie.tagline, title: @movie.title } }
    assert_redirected_to movie_url(@movie)
  end

  test "should destroy movie" do
    assert_difference('Movie.count', -1) do
      delete movie_url(@movie)
    end

    assert_redirected_to movies_url
  end
end
