class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: [:create, :new, :show, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :update]
  before_action :set_user, only: [:create, :edit, :update, :destroy]
  before_action :require_admin, only: [:index]

  def index
    @pagy, @reviews = pagy(Review.includes(:user, :movie).all.order(created_at: :desc), items: 33)
  end

  def new
    @page_title = 'Add Review'
    @review = Review.new
  end

  def edit; end

  def create
    return unless params[:rating].present?

    @movie.reviews.where(user_id: @user.id, rating: params[:rating]).first_or_create
    @user_reviews = @user.reviews
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
    @movie.reviews.where(user_id: @user.id).destroy_all
    @user_reviews = @user.reviews

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
    @movie ||= Movie.find(params[:movie_id])
  end

  def review_params
    params
      .require(:review)
      .permit(:rating, :movie_id)
  end

end
