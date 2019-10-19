class MoviesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_movie, only: %i[show edit update destroy]
  before_action :set_review, only: %i[show edit update destroy]
  before_action :set_lists, only: %i[index show edit update destroy]
  before_action :set_reviews, only: %i[index show]
  before_action :require_admin, only: %i[create new edit update destroy]
  before_action :set_per_page, only: %i[index]

  # GET /movies
  # GET /movies.json
  def index
    @page_title = 'Movies'
    @pagy, @movies = pagy(Movie.where(status: 0).order(popularity: :desc, release_date: :desc), items: @per_page)
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @page_title = @movie.title
  end

  # GET /movies/new
  def new
    @page_title = 'New Movie'
    @movie = Movie.new
    @genres = Genre.all
  end

  # GET /movies/1/edit
  def edit
    @page_title = 'Edit Movie'
    @genres = Genre.all
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        @movie.genres.create(params[:genre])
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie ||= Movie.find(params[:id])
    @genres = @movie.genres
    @companies = @movie.companies
  end

  def set_review
    @review = nil unless user_signed_in?
    @review = Review.where(movie_id: params[:id], user_id: current_user.id)
  end

  def set_reviews
    return @user_reviews if defined? @user_reviews

    @user_reviews = (current_user.reviews if user_signed_in?)
  end

  # Never trust parameters from the scary internet
  # only allow the white list through.
  def movie_params
    accessible = [:title, :vote_count, :vote_average, :tagline, :status, :poster_path, :original_language, :backdrop_path, :adult, :overview, :popularity, :budget, :release_date, :revenue, :runtime, genre_ids: []]
    params.require(:movie).permit(accessible)
  end

  # Utility methods
  def genres
    @genres = Genre.all
    @movie_genres = @movie.categorizations.build
  end
end
