class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: %i[create new destroy]
  before_action :set_user, only: %i[create destroy]
  before_action :set_review, only: %i[destroy]
  before_action :require_admin, only: [:index]

  # GET /reviews
  # GET /reviews.json
  def index
    @page_title = 'Reviews'
    @pagy, @reviews = pagy(Review.includes(:user, :movie).all, items: 60)
  end

  # GET /reviews/new
  def new
    @page_title = 'Add Review'
    @review = Review.new
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @user_reviews = @user.reviews
    return unless params[:rating].present?

    if !@movie.released?
      respond_to do |format|
        format.html { redirect_to movie_path(@movie) }
        format.js { flash[:alert] = 'Not Released Yet' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    else
     @movie.reviews.where(user_id: @user.id, rating: params[:rating]).first_or_create
      respond_to do |format|
        format.html { redirect_to movie_path(@movie) }
        format.js { flash[:notice] = 'Review added' }
        format.json { render :show, status: :created, location: @movie }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    if @review.destroy
      @user_reviews = @user.reviews

      respond_to do |format|
        format.js {  flash[:notice] = 'Review was successfully destroyed' }
        format.html { redirect_to @movie, notice: 'Review was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.js {  flash[:alert] = 'Review was not destroyed' }
        format.html { redirect_to @movie, alert: 'Review was not destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private

  def set_review
    @review ||= Review.find(params[:id])
  end

  def set_movie
    unless (@movie ||= Movie.find(params[:movie_id]))
      flash[:warning] = 'Review must be for an existing movie.'
      redirect_to movies_path
    end

  end

  def review_params
    params
      .require(:review)
      .permit(:rating, :movie_id)
  end
end
