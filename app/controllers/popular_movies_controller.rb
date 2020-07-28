
class PopularMoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[index]
  before_action :set_lists, only: %i[index show edit update destroy]
  before_action :set_reviews, only: %i[index show]
  before_action :set_per_page, only: %i[index]

  def index
    @page_title = 'Popular Movies'
    @list = List.find(23)
    @pagy, @movies = pagy(@list.movies, items: @per_page)
  end

  def set_reviews
    return @user_reviews if defined? @user_reviews

    @user_reviews = (current_user.reviews if user_signed_in?)
  end

end
