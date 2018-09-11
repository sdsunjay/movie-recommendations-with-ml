require "application_system_test_case"

class MoviesTest < ApplicationSystemTestCase
  setup do
    @movie = movies(:one)
  end

  test "visiting the index" do
    visit movies_url
    assert_selector "h1", text: "Movies"
  end

  test "creating a Movie" do
    visit movies_url
    click_on "New Movie"

    fill_in "Budget", with: @movie.budget
    fill_in "Genre", with: @movie.genre_id
    fill_in "Imdb", with: @movie.imdb_id
    fill_in "Overview", with: @movie.overview
    fill_in "Popularity", with: @movie.popularity
    fill_in "Poster Path", with: @movie.poster_path
    fill_in "Release Date", with: @movie.release_date
    fill_in "Revenue", with: @movie.revenue
    fill_in "Runtime", with: @movie.runtime
    fill_in "Status", with: @movie.status
    fill_in "Tagline", with: @movie.tagline
    fill_in "Title", with: @movie.title
    click_on "Create Movie"

    assert_text "Movie was successfully created"
    click_on "Back"
  end

  test "updating a Movie" do
    visit movies_url
    click_on "Edit", match: :first

    fill_in "Budget", with: @movie.budget
    fill_in "Genre", with: @movie.genre_id
    fill_in "Imdb", with: @movie.imdb_id
    fill_in "Overview", with: @movie.overview
    fill_in "Popularity", with: @movie.popularity
    fill_in "Poster Path", with: @movie.poster_path
    fill_in "Release Date", with: @movie.release_date
    fill_in "Revenue", with: @movie.revenue
    fill_in "Runtime", with: @movie.runtime
    fill_in "Status", with: @movie.status
    fill_in "Tagline", with: @movie.tagline
    fill_in "Title", with: @movie.title
    click_on "Update Movie"

    assert_text "Movie was successfully updated"
    click_on "Back"
  end

  test "destroying a Movie" do
    visit movies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Movie was successfully destroyed"
  end
end
