class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]


  def index
    @reviews = Review.all.order(created_at: :desc).paginate(per_page: 10, page: params[:page])
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
      redirect_to root_path
    else
      flash[:alert] = "Review Not Updated"
      render 'edit'
    end
  end

  # def destroy
  #   if @review.destroy
  #     flash[:notice] = 'Review Deleted'
  #     redirect_to post_path
  #   else
  #     render 'destroy'
  #   end
  # end

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
      .permit(:rating, )
      .merge(movie_id: @movie.id, user_id: current_user.id)
  end

end
