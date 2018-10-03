class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: [:create, :new, :show, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update]
  before_action :require_admin, only: [:index]

  def index
    @pagy, @reviews = pagy(Review.all.order(created_at: :desc), items: 33)
  end

  def new
    @page_title = 'Add Review'
    @review = Review.new
  end

  def edit; end

  def create
    return unless params[:rating].present?

    @movie.review.where(user_id: current_user.id, rating: params[:rating]).first_or_create
      respond_to do |format|
        format.html {redirect_to movies_path}
        format.js
      end
  end

  def update
    if @review.update(review_params)
      flash[:notice] = "Review Updated"
      redirect_to movie_path(@movie)
    else
      flash[:alert] = "Review Not Updated"
      render 'edit'
    end
  end

  def destroy
    @movie.review.where(user_id: current_user.id).destroy_all

    respond_to do |format|
      format.html { redirect_to @movie }
      format.js
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def review_params
    params
      .require(:review)
      .permit(:rating, :movie_id)
  end

end
