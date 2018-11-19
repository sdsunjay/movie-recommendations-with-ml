class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: %i[create new show edit update destroy]
  before_action :set_review, only: %i[show update destroy]
  before_action :set_user, only: %i[create edit update destroy]
  before_action :require_admin, only: [:index]

  # GET /reviews
  # GET /reviews.json
  def index
    @pagy, @reviews = pagy(Review.includes(:user, :movie).all, items: 60)
  end

  # GET /reviews/new
  def new
    @page_title = 'Add Review'
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit; end

  # POST /reviews
  # POST /reviews.json
  def create
    @user_reviews = @user.reviews
    return unless params[:rating].present?

    if !@movie.released?
      respond_to do |format|
        format.html { redirect_to movies_path }
        format.js { flash[:alert] = 'Not Released Yet' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    else
      @movie.reviews.where(user_id: @user.id, rating: params[:rating]).first_or_create
      respond_to do |format|
        format.html { redirect_to movies_path }
        format.js { flash[:notice] = 'Review added' }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @movie, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
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
    @review ||= current_user.reviews.find(params[:id])
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
