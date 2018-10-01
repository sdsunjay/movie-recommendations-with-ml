class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:index]

  def index
    @pagy, @reviews = pagy(Review.all.order(created_at: :desc), items: 33)
  end

  def new
    @page_title = 'Add Review'
    @review = Review.new
  end

  def edit
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:notice] = "Review Created"
      redirect_to root_path
    else
      flash[:alert] = "Review Not Created"
      render 'new'
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
     if @review.destroy
       flash[:notice] = 'Review Deleted'
       redirect_to movie_path(@movie)
     else
       render 'destroy'
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
