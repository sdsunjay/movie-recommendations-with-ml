class MovieUserRecommendationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[index show edit update destroy]
  before_action :set_movie_user_recommendation, only: %i[show edit update destroy]
  before_action :require_admin

  # GET /movie_user_recommendations
  # GET /movie_user_recommendations.json
  def index
    @page_title = 'Movie Recommendations'
    @pagy, @recommendations = pagy(MovieUserRecommendation.includes(:user, :movie).all, items: 99)
  end

  # GET /movie_user_recommendations/1
  # GET /movie_user_recommendations/1.json
  def show
    @page_title = 'Movie Recommendation'
  end

  # GET /movie_user_recommendations/new
  def new
    @page_title = 'New Movie Recommendation'
    @movie_user_recommendation = MovieUserRecommendation.new
  end

  # GET /movie_user_recommendations/1/edit
  def edit
    @page_title = 'Edit Movie Recommendation'
  end

  # POST /movie_user_recommendations
  # POST /movie_user_recommendations.json
  def create
    @movie_user_recommendation = MovieUserRecommendation.new(movie_user_recommendation_params)

    respond_to do |format|
      if @movie_user_recommendation.save
        format.html { redirect_to @movie_user_recommendation, notice: 'Recommendation was successfully created.' }
        format.json { render :show, status: :created, location: @movie_user_recommendation }
      else
        format.html { render :new }
        format.json { render json: @movie_user_recommendation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movie_user_recommendations/1
  # PATCH/PUT /movie_user_recommendations/1.json
  def update
    respond_to do |format|
      if @movie_user_recommendation.update(movie_user_recommendation_params)
        format.html { redirect_to @movie_user_recommendation, notice: 'Recommendation was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie_user_recommendation }
      else
        format.html { render :edit }
        format.json { render json: @movie_user_recommendation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movie_user_recommendations/1
  # DELETE /movie_user_recommendations/1.json
  def destroy
    @movie_user_recommendation.destroy
    respond_to do |format|
      format.html { redirect_to movie_user_recommendations_url, notice: 'Recommendation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_movie_user_recommendation
    @recommendation ||= MovieUserRecommendation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def movie_user_recommendation_params
    # extend with your own params
    accessible = %i[movie_id user_id confidence user_rating]
    params.require(:movie_user_recommendation).permit(accessible)
  end
end
